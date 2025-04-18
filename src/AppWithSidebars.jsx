/** @jsx vNode */ /** @jsxFrag "Fragment" */



/**
 * This is the default App component.
 * It should reflect an agnostic implementation of the basic repository features.
 */


import { vNode, View } from "@ocdla/view/view.js";
import Navbar from "@ocdla/global-components/src/Navbar";
import Breadcrumbs from "@ocdla/global-components/src/Breadcrumbs";
import Sidebar from "@ocdla/global-components/src/Sidebar";
import Footer from "@ocdla/global-components/src/Footer";

export default function App({
    view,
    children,
    crumbs,
    sidebarFirstItems,
    sidebarSecondItems
}) {
    return (
        <>
            <div class="group absolute right-0 m-4 flex gap-2 lg:left-0 lg:m-2">
                <button
                    class="select-none whitespace-pre font-bold"
                    onclick={() => {
                        view.render("foo");
                    }}></button>
            </div>
            <header class="flex flex-col lg:h-32">
                <Navbar />
                <Breadcrumbs
                    items={crumbs}
                    separator="/"
                />
            </header>
            <div class="container mx-auto border-x">
                <div class="lg:grid lg:grid-cols-6">
                    <Sidebar items={sidebarFirstItems} />
                    <main class="flex w-full flex-col gap-4 p-4 lg:col-span-4 lg:col-start-2 lg:me-auto lg:border-x lg:p-8">
                        {children}
                    </main>
                    <Sidebar items={sidebarSecondItems} />
                </div>
            </div>
            <footer class="container mx-auto flex flex-col gap-4 border border-b-0 p-4 pb-16 lg:flex-row lg:gap-0 lg:p-8 lg:pb-16">
                <Footer />
            </footer>
        </>
    );
}
