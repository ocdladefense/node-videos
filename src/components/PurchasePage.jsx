import React, { useState } from 'react';
import Modal from './Modal';

export default function PurchasePage({ video, onBack }) {
    // const videoId = video.getResourceId();

    // const [showModal, setShowModal] = useState(false);
    // const [processing, setProcessing] = useState(false);

    // const handlePurchase = async () => {
    //     setProcessing(true);
    //     try {
    //         let response = await fetch(`/services/apexrest/api/media/${videoId}/purchase`, {
    //             method: 'POST',
    //             headers: { 'Content-Type': 'application/json' },
    //             body: JSON.stringify({ contactId: '003VC00000rtzKUYAY' }) // Hard-coded contactId
    //         });

    //         if (response.ok) {
    //             alert("Purchase successful!");
    //         } else {
    //             alert("Purchase failed.");
    //         }
    //     } catch (err) {
    //         console.error(err);
    //         alert("Error occurred.");
    //     } finally {
    //         setProcessing(false);
    //         onBack(); // return to details
    //         //setShowModal(false); // close modal after
    //     }
    // };

    return (
        <div>
            <h1>Hello</h1>
        </div>
        // <div>
        //     <h1 className="text-2xl font-bold mb-4">Purchase {video.getVideoName()}</h1>
        //     <p>Would you like to purchase this video for <strong>$19.99</strong>?</p>

        //     {/* later: form for card details goes here */}

        //     <div className="mt-4 flex gap-2">
        //         <button
        //             onClick={onBack}
        //             className="bg-gray-500 text-white px-4 py-2 rounded"
        //         >
        //             Cancel
        //         </button>
        //         <button
        //             onClick={handlePurchase}
        //             disabled={processing}
        //             className="bg-blue-600 text-white px-4 py-2 rounded"
        //         >
        //             {processing ? "Processing..." : "Confirm Purchase"}
        //         </button>
        //     </div>

        //     {showModal && (
        //         <Modal
        //             setShowModal={setShowModal}
        //             confirmAction={handlePurchase}
        //             title="Confirm Purchase"
        //         >
        //             <p>Do you really want to purchase this media item?</p>
        //         </Modal>
        //     )}
        // </div>
    );
}
