/* eslint-disable no-unused-vars */
import { vNode } from '@ocdla/view';
import Link from './Defaults';
import Logo from './Logo';
import Social from './Social';
import Google_Maps from './GoogleMaps';
/* eslint-enable */

export default function Footer({
    showFacebook,
    showTwitter,
    showYouTube,
    useGoogleMapsIFrame
}) {
    return (
        <footer className='container mx-auto p-4 pb-16 lg:p-8 lg:pb-32'>
            {/* Resources */}
            <ul id="ul-depth-1" className='flex flex-col gap-4'>
                <li>
                    {/* Organization */}
                    <ul className='flex flex-col gap-4 lg:flex-row lg:gap-8'>
                        <li>
                            <ul id="ul-depth-2" className='flex flex-col gap-1'>
                                {/* Brand + Social */}
                                <li>
                                    <ul id="ul-depth-3" className='flex items-center gap-1'>
                                        <Logo />
                                        {showFacebook && (
                                            <Social
                                                type='facebook'
                                                handle='OregonCriminalDefenseLawyersAssociation'
                                            />
                                        )}
                                        {showTwitter && (
                                            <Social
                                                type='twitter'
                                                handle='oregondefense'
                                            />
                                        )}
                                        {showYouTube && (
                                            <Social
                                                type='youtube'
                                                handle='oregoncriminaldefenselawye4822'
                                            />
                                        )}
                                    </ul>
                                </li>
                                {/* Copyright */}
                                <li>
                                    <ul id="ul-depth-3" className='text-[0.625rem] font-thin leading-[0.75rem] text-neutral-500'>
                                        <li>
                                            ©2024 Oregon Criminal Defense
                                            Lawyers Association
                                        </li>
                                        <li className='size-full text-wrap'>
                                            Oregon Criminal Defense Lawyers
                                            Association is a 501(c)(3) nonprofit
                                            educational association.
                                            Contributions to OCDLA may be tax
                                            deductible - check with your tax
                                            advisor. Electronic downloads are
                                            for the sole use of the purchasing
                                            member. Files may not be distributed
                                            to others.
                                        </li>
                                    </ul>
                                </li>
                                {/* Contact */}
                                <li>
                                    <ul className='text-neutral-300'>
                                        <Link href='https://ocdla.org'>
                                            ocdla.org
                                        </Link>
                                        {!useGoogleMapsIFrame &&
                                            <Link href='https://maps.app.goo.gl/7dCYKBEyJbmo8tzS7'>
                                                101 East 14th Ave, Eugene,  OR 97401
                                            </Link>
                                        }
                                        <br />
                                        <Link href='mailto:info@ocdla.org'>
                                            info@ocdla.org
                                        </Link>
                                        <br />
                                        <Link href='tel:+15416868716'>
                                            (+1) 541-686-8716
                                        </Link>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                        <li className='size-full'>
                            <ul className='flex flex-col gap-8 text-nowrap text-[#516490] lg:flex-row lg:gap-16'>
                                <li>
                                    <ul className='flex flex-col gap-1'>
                                        <li>
                                            <p className='text-base font-bold'>
                                                SERVICES
                                            </p>
                                        </li>
                                        <li>
                                            <Link href='https://pubs.ocdla.org/directory/members'>
                                                Membership Directory
                                            </Link>
                                        </li>
                                        <li>
                                            <Link href='https://pubs.ocdla.org/directory/experts'>
                                                Expert Directory
                                            </Link>
                                        </li>
                                        <li>
                                            <Link href='/'>Online store</Link>
                                        </li>
                                    </ul>
                                </li>
                                <li>
                                    <ul className='flex flex-col gap-1'>
                                        <li>
                                            <p className='text-base font-bold'>
                                                RESEARCH
                                            </p>
                                        </li>
                                        <li>
                                            <Link href='https://pubs.ocdla.org/car/list'>
                                                Research Criminal Appellate Review
                                            </Link>
                                        </li>
                                        <li>
                                            <Link href='https://lod.ocdla.org/'>
                                                Library of Defense
                                            </Link>
                                        </li>
                                        <li>
                                            <Link href='https://lod.ocdla.org/Public:Subscriptions'>
                                                Books Online
                                            </Link>
                                        </li>
                                    </ul>
                                </li>
                                <li>
                                    <ul className='flex flex-col gap-1'>
                                        <li>
                                            <p className='text-base font-bold'>
                                                RESOURCES
                                            </p>
                                        </li>
                                        <li>
                                            <Link href='/'>CLEs</Link>
                                        </li>
                                        <li>
                                            <Link href='/'>Videos</Link>
                                        </li>
                                        <li>
                                            <Link href='/'>
                                                Seminars & Events
                                            </Link>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                    </ul>
                </li>
                {/* Location */}
                {useGoogleMapsIFrame ? (
                    <Google_Maps src='https://google.com/maps/embed?pb=!1m18!1m12!1m3!1d2867.8775315978623!2d-123.09091950000001!3d44.0445852!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x54c11e41b2e3f7ad%3A0xa7600cd512aa10ed!2s101%20E%2014th%20Ave%2C%20Eugene%2C%20OR%2097401!5e0!3m2!1sen!2sus!4v1722628072318!5m2!1sen!2sus' />
                ) : <li></li>}
            </ul>
        </footer>
    );
}
