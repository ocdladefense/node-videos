import React, { useState } from 'react';
import Modal from './Modal';

export default function PurchasePage() {
    const [showModal, setShowModal] = useState(false);

    const handlePurchase = async () => {
        try {
            let response = await fetch('/services/apexrest/api/media/purchase/123', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ contactId: '003VC00000rtzKUYAY' })
            });

            if (response.ok) {
                alert("Purchase successful!");
            } else {
                alert("Purchase failed.");
            }
        } catch (err) {
            console.error(err);
            alert("Error occurred.");
        } finally {
            setShowModal(false); // close modal after
        }
    };

    return (
        <div>
            <button
                onClick={() => setShowModal(true)}
                className="bg-blue-600 text-white px-4 py-2 rounded">
                Buy Now
            </button>

            {showModal && (
                <Modal
                    setShowModal={setShowModal}
                    confirmAction={handlePurchase}
                    title="Confirm Purchase"
                >
                    <p>Do you really want to purchase this media item?</p>
                </Modal>
            )}
        </div>
    );
}
