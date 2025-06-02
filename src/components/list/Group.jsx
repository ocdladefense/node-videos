import TitleComponent from '../TitleComponent';
import VideoList from './VideoList';

export default function Group({ groups, labels, user }) {


    let keys = Object.keys(groups);


    return (
        <ul>
            {
                keys.map(key => {
                    let theGroup = groups[key];
                    let theLabel = labels.get(key);
                    let numVideos = theGroup.length;

                    if (true || numVideos > 2) {

                        return (

                            <VideoList videos={theGroup} label={theLabel} user={user} />
                        )
                    }
                })
            }


        </ul>);
}
