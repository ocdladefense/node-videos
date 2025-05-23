/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
import Logo from './Logo';
import Navlink from './Navlink';
import { DividerMobile, DividerDesktop } from './Dividers';
import Search from './Search';
import Profile from './Profile';
import Button from './Button';
/* eslint-enable */

export default function Navbar() {
    return (
        <nav style={{ position: "sticky" }} className='flex flex-col border border-0 border-b lg:h-16 lg:flex-row lg:border lg:border-t-0'>
            <ul className='flex size-full flex-col items-start lg:flex-row lg:items-center'>
                <li className='size-full lg:size-max'>
                    <ul className='flex flex-col items-center lg:flex-row'>
                        <Logo typeNavbar={true} />
                        {/*<Navlink href='https://oregon.public.law/rules'>
                            Oregon Administrative Rules
                        </Navlink>
                        <Navlink
                            // href='https://oregon.public.law/statutes'
                            href='/toc'>
                            Oregon Revised Statutes
                        </Navlink>*/}
                    </ul>
                </li>
                <DividerMobile />
                <li className='size-full lg:ms-auto lg:size-max'>
                    <form
                        className='m-4 flex flex-col items-start lg:m-0 lg:flex-row lg:items-center'
                        onsubmit={e => {
                            e.preventDefault();

                            window.location.pathname = '/';
                        }}>
                        <Search
                            typeNavbar={true}
                            placeholder='Search'
                        />
                        <DividerDesktop />
                        <li className='size-full'>
                            <ul className='flex flex-row-reverse items-center lg:flex-row'>
                                <Button
                                    href='/'
                                    label='GIVE FEEDBACK'
                                />
                                <DividerDesktop />
                                <Profile
                                    bg='bg-[#516490]'
                                    label='G'
                                />

                            </ul>
                        </li>
                    </form>
                </li>
            </ul>
        </nav>
    );
}
