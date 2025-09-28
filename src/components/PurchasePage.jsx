import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from "react-router";
import { useOutletContext } from 'react-router-dom';
import Modal from './Modal';

export default function PurchasePage(/* { video, onBack } */) {
    let params = useParams();
    let videoId = params.resourceId;

    let { user } = useOutletContext();

    let navigate = useNavigate();
    const onBack = function() { navigate("/media/" + videoId); };

    //const [showModal, setShowModal] = useState(false);
    const [processing, setProcessing] = useState(false);
    const [purchased, setPurchased] = useState(false);

    const handlePurchase = async () => {
        setProcessing(true);
        try {
            let response = await user.purchase(videoId);

            if (response) {
                console.log("Purchase successful");

            } else {
                console.error("Purchase failed. Status:", response.status, "Text:", await response.text());
                console.log("Purchase failed.");
            }

            // let response = await fetch(`/services/apexrest/api/media/${videoId}/purchase`, {
            //     method: 'POST',
            //     headers: { 'Content-Type': 'application/json' },
            //     body: JSON.stringify({ contactId: '003VC00000rtzKUYAY' }) // Hard-coded contactId
            // });

            // if (response.ok) {
            //     console.log("Purchase successful");
            // } else {
            //     console.error("Purchase failed. Status:", response.status, "Text:", await response.text());
            //     console.log("Purchase failed.");
            // }
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


    {/* Test form */ }
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

    {/*Full form*/ }
    // return (
    //     <div className="flex justify-center items-start bg-zinc-900 text-zinc-100 p-4">
    //         <div className="w-full max-w-xl p-8 rounded-2xl shadow-lg bg-zinc-800 border border-zinc-700 h-auto">
    //             <h1 className="text-3xl font-bold text-center mb-6">Purchase Video</h1>
    //             <div className="flex justify-center items-center bg-zinc-900 text-zinc-100 p-4 rounded-xl">
    //                 <form onSubmit={handleSubmit} className="space-y-4">

    //                     {/* Billing Address */}
    //                     <h2 className="text-xl font-semibold mt-4">Billing Address</h2>

    //                     <div>
    //                         <label htmlFor="street" className="block text-sm font-medium mb-1">
    //                             Street Address
    //                         </label>
    //                         <input
    //                             id="street"
    //                             type="text"
    //                             placeholder="123 Main St"
    //                             className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                    focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                             required
    //                         />
    //                     </div>

    //                     <div className="flex gap-4">
    //                         <div className="flex-1">
    //                             <label htmlFor="city" className="block text-sm font-medium mb-1">
    //                                 City
    //                             </label>
    //                             <input
    //                                 id="city"
    //                                 type="text"
    //                                 placeholder="Springfield"
    //                                 className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                        focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                                 required
    //                             />
    //                         </div>
    //                         <div className="flex-1">
    //                             <label htmlFor="state" className="block text-sm font-medium mb-1">
    //                                 State
    //                             </label>
    //                             <input
    //                                 id="state"
    //                                 type="text"
    //                                 placeholder="OR"
    //                                 className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                        focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                                 required
    //                             />
    //                         </div>
    //                     </div>

    //                     <div className="flex gap-4">
    //                         <div className="flex-1">
    //                             <label htmlFor="zip" className="block text-sm font-medium mb-1">
    //                                 ZIP Code
    //                             </label>
    //                             <input
    //                                 id="zip"
    //                                 type="text"
    //                                 inputMode="numeric"
    //                                 placeholder="97477"
    //                                 className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                        focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                                 required
    //                             />
    //                         </div>
    //                         <div className="flex-1">
    //                             <label htmlFor="country" className="block text-sm font-medium mb-1">
    //                                 Country
    //                             </label>
    //                             <input
    //                                 id="country"
    //                                 type="text"
    //                                 placeholder="United States"
    //                                 className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                        focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                                 required
    //                             />
    //                         </div>
    //                     </div>

    //                     {/* Payment Details */}
    //                     <h2 className="text-xl font-semibold mt-6">Payment Details</h2>

    //                     <div>
    //                         <label htmlFor="cardName" className="block text-sm font-medium mb-1">
    //                             Cardholder Name
    //                         </label>
    //                         <input
    //                             id="cardName"
    //                             type="text"
    //                             placeholder="John Doe"
    //                             className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                    focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                             required
    //                         />
    //                     </div>

    //                     <div>
    //                         <label htmlFor="cardNumber" className="block text-sm font-medium mb-1">
    //                             Card Number
    //                         </label>
    //                         <input
    //                             id="cardNumber"
    //                             type="text"
    //                             inputMode="numeric"
    //                             placeholder="1234 5678 9012 3456"
    //                             className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                    focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                             required
    //                         />
    //                     </div>

    //                     <div className="flex gap-4">
    //                         <div className="flex-1">
    //                             <label htmlFor="expDate" className="block text-sm font-medium mb-1">
    //                                 Expiration Date
    //                             </label>
    //                             <input
    //                                 id="expDate"
    //                                 type="text"
    //                                 placeholder="MM/YY"
    //                                 className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                        focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                                 required
    //                             />
    //                         </div>
    //                         <div className="flex-1">
    //                             <label htmlFor="cvv" className="block text-sm font-medium mb-1">
    //                                 CVV
    //                             </label>
    //                             <input
    //                                 id="cvv"
    //                                 type="password"
    //                                 inputMode="numeric"
    //                                 placeholder="123"
    //                                 className="w-full p-2.5 rounded-md bg-zinc-700 border border-zinc-600 
    //                                        focus:outline-none focus:ring-2 focus:ring-blue-500"
    //                                 required
    //                             />
    //                         </div>
    //                     </div>

    //                     {/* Confirm button */}
    //                     <button
    //                         type="submit"
    //                         className="w-full py-2 rounded-md bg-blue-600 text-white font-semibold 
    //                                hover:bg-blue-500 transition-colors duration-200 
    //                                disabled:opacity-50 disabled:cursor-not-allowed"
    //                         disabled={processing}
    //                     >
    //                         {processing ? "Processing..." : "Confirm Purchase"}
    //                     </button>
    //                 </form>
    //             </div>
    //         </div>
    //     </div>
    // );

}
