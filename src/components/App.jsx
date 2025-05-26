import Header from "./Header";
import Footer from "./Footer";
import Home from "./Home";


// https://nextjs.org/docs/app/guides/migrating/from-create-react-app


export function App2({ user }) {


    return (
        <div id="the-app-container">
            <div class='fixed right-0 z-10 flex w-max gap-2 p-4 lg:left-0 lg:p-2'></div>
            <header class="container mx-auto flex w-full flex-col top-of-page">
                <Navbar />
            </header>
            <div class="container mx-auto">
                <Home user={user} />
            </div>
            <Footer
                showFacebook={true}
                showTwitter={true}
                useGoogleMapsIFrame={true}
            />
        </div>
    );
}


export default function App({ user }) {


    return (
        <>
            <Header />
            {/* typeof HeaderTwo === "function" ? <HeaderTwo /> : <></> */}
            <div class="container mx-auto">
                <Home user={user} />
            </div>
            <Footer />
        </>
    );
}
