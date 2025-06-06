import VideoList from './VideoList';

export default function Group({ groups, labels, user }) {


    let keys = Object.keys(groups);

    if (keys[0].length == 4) {
        keys.reverse();
    }

    return (
        <ul>
            {
                keys.map(key => {
                    let next = groups[key];
                    let label;
                    if (key.length > 4) {
                        label = labels.get(key);
                    } else {
                        label = key;
                    }

                    let count = next.length;
                    console.log(label);

                    return <VideoList videos={next} label={label} user={user} />
                })
            }
        </ul>);
}
