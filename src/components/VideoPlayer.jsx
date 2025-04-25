import React from 'react';


export default function VideoPlayer({ video, onBack }) {
    const youtube = 'https://www.youtube.com/watch?v=';

  return (
    <div className="video-details">
      <button onClick={onBack}>← Back to List</button>
      <h2>{video.title}</h2>
      <img src={video.largeThumbnail} alt={video.title} style={{ maxWidth: '100%' }} />
      <p><strong>Title:</strong> {video.getVideoName()}</p>
      <p><strong>Description:</strong> {video.getVideoDescription()}</p>
      <p><strong>Published:</strong> {String(video.getVideoPublished())}</p>
      <video controls width="600">
        <source src={youtube+video.getVideoResourceId()} type="video/mp4" />
        {console.log(youtube+video.getVideoResourceId())}
        Your browser does not support the video tag.
      </video>
    </div>
  );
}






