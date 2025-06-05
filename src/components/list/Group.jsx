import VideoList from './VideoList';

export default function Group({ groups, labels, user }) {


    let keys = Object.keys(groups);


    return (
        <ul>
            {
                keys.map(key => {
                    let next = groups[key];
                    let label = labels.get(key);
                    let count = next.length;

                    return <VideoList videos={next} label={label} user={user} />
                })
            }
        </ul>);
}
