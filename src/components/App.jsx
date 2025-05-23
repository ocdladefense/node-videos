import Navbar from "@ocdla/global-components/src/Navbar";
import Home from "./Home";
import Footer from "@ocdla/global-components/src/Footer";


// https://nextjs.org/docs/app/guides/migrating/from-create-react-app


export default function App({ user }) {


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
