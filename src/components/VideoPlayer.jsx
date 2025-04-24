import React from 'react';

export default function VideoPlayer({ video, onBack }) {
  return (
    <div className="video-details">
      <button onClick={onBack}>← Back to List</button>
      <h2>{video.title}</h2>
      <img src={video.largeThumbnail} alt={video.title} style={{ maxWidth: '100%' }} />
      <p><strong>Description:</strong> {video.description}</p>
      <p><strong>Published:</strong> {video.publishedAt}</p>
      <video controls width="600">
        <source src={video.videoUrl} type="video/mp4" />
        Your browser does not support the video tag.
      </video>
    </div>
  );
}

