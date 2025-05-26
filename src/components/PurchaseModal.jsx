

export default function PurchaseModal({ setShowModal, confirmPurchase }) {


    return (
        <div className="fixed inset-0 z-30 flex items-center justify-center bg-black bg-opacity-70">
            <div className="bg-white rounded-xl p-6 w-96 shadow-xl">
                <h2 className="text-2xl font-semibold mb-4">Confirm Purchase</h2>
                <p className="mb-6">Would you like to purchase this video for <strong>$19.99</strong>?</p>
                <div className="flex justify-end space-x-4">
                    <button onClick={() => setShowModal(false)} className="bg-gray-300 px-4 py-2 rounded">Cancel</button>
                    <button onClick={confirmPurchase} className="bg-green-600 text-white px-4 py-2 rounded">Confirm</button>
                </div>
            </div>
        </div>
    )
}
