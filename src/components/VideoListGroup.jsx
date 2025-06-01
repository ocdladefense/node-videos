import TitleComponent from './TitleComponent';


export default function VideoListGroup({ groups, user, setSelectedVideo }) {


    return (<ul>
        {
            Object.keys(groups).map(key => {
                let theGroup = groups[key];
                let numVideos = theGroup.length;

                if (true || numVideos > 2) {

                    return (

                        <ul className="video-list grid phone:grid-cols-1 tablet:grid-cols-2 laptop:grid-cols-4 desktop:grid-cols-5 gap-8">
                            <li className='text-4xl text-zinc-100 grid col-span-full mt-10'>{key}</li>
                            <hr className='grid col-span-full text-zinc-100 -mt-5' />
                            {theGroup.map((video, index) => (

                                <TitleComponent video={video} index={index} setSelectedVideo={setSelectedVideo} user={user} />

                            ))}
                        </ul>
                    )
                }
            })
        }


    </ul>);
}
