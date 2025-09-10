import React, { useState } from 'react';
import { useParams, useNavigate } from "react-router";
import Modal from './Modal';

export default function PurchasePage(/* { video, onBack } */) {
    let params = useParams();
    let videoId = params.resourceId;

    let navigate = useNavigate();
    const onBack = function() { navigate("/"); };

    //const [showModal, setShowModal] = useState(false);
    const [processing, setProcessing] = useState(false);

    const handlePurchase = async () => {
        setProcessing(true);
        try {
            let response = await fetch(`/services/apexrest/api/media/${videoId}/purchase`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ contactId: '003VC00000rtzKUYAY' }) // Hard-coded contactId
            });

            if (response.ok) {
                console.log("Purchase successful");
            } else {
                console.error("Purchase failed. Status:", response.status, "Text:", await response.text());
                console.log("Purchase failed.");
            }
        } catch (err) {
            console.error(err);
            alert("Error occurred.");
        } finally {
            setProcessing(false);
            onBack(); // return to details
            //setShowModal(false); // close modal after
        }
    };

    // Function that handles the form submission
    const handleSubmit = (event) => {
        event.preventDefault(); // Prevents the default form submission behavior
        handlePurchase();
    };

    return (
        <div className="flex justify-center">
            <div className="w-full max-w-xl p-8 rounded-lg shadow-lg bg-zinc-800 border border-zinc-700">
                <h1 className="text-3xl font-bold text-center mb-6">Purchase Video</h1>
                <div className="flex justify-center items-center min-h-screen bg-zinc-900 text-zinc-100 p-4">
                    <form onSubmit={handleSubmit}>
                        <label htmlFor="purchaseFormInput" className="block text-sm font-medium mb-1">
                            Form:
                        </label>
                        <input
                            type="text"
                            className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 focus:outline-none focus:ring-2 focus:ring-blue-500"
                        />
                        <button
                            type="submit"
                            className="flex-1 py-2 rounded-md bg-blue-600 text-white font-semibold hover:bg-blue-500 transition-colors duration-200 disabled:opacity-50 disabled:cursor-not-allowed"
                            disabled={processing}
                        >
                            {processing ? "Processing..." : "Confirm Purchase"}
                        </button>
                    </form>
                </div>
            </div>
        </div>
    );
}
