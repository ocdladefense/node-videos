import React, { useState } from 'react';




export default function Modal({ setShowModal, confirmAction, title = "Confirm Purchase", children }) {


    return (
        <div className="fixed inset-0 z-30 flex items-center justify-center bg-black bg-opacity-70">
            <div className="bg-white rounded-xl p-6 w-96 shadow-xl">
                <h2 className="text-2xl font-semibold mb-4">{title}</h2>
                {children}
                <div className="flex justify-end space-x-4">
                    <button onClick={() => setShowModal(false)} className="bg-gray-300 px-4 py-2 rounded">Cancel</button>
                    <button onClick={confirmAction} className="bg-green-600 text-white px-4 py-2 rounded">Confirm</button>
                </div>
            </div>
        </div>
    )
}
