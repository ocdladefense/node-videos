import TitleComponent from '../TitleComponent';





/**
 * 
 * @param {Array<Video>} videos
 * @param {User} user
 * @param {function} setSelectedVideo 
 * @returns 
 */
export default function VideoList({ videos, user, label }) {


    return (

        <ul className="video-list grid phone:grid-cols-1 tablet:grid-cols-2 laptop:grid-cols-4 desktop:grid-cols-5 gap-8">
            {label && <li className='text-4xl text-zinc-100 grid col-span-full mt-10'>{label}</li>}
            {videos.map((video, index) => (

                <TitleComponent video={video} index={index} user={user} />

            ))}
        </ul>

    );

}
