/**
 * https://expressjs.com/en/starter/hello-world.html
 * OpenID: https://help.salesforce.com/s/articleView?id=xcloud.remoteaccess_using_openid.htm&type=5
 * So we can extract some user information.
 */


// require('dotenv').config();
import dotenv from "dotenv";
dotenv.config();
import express from "express";
import cookieParser from "cookie-parser";
import path from "path";
import { access } from "fs";
import { fileURLToPath } from 'url';
import SalesforceRestApi from '@ocdla/salesforce/SalesforceRestApi.js';



const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const app = express();
const port = process.env.PORT || 80;


const SF_ACCESS_TOKEN = process.env.SF_OAUTH_SESSION_ACCESS_TOKEN_OVERRIDE;




// Serve static files from the 'dist' directory
app.use(express.static('dist'));


app.use(cookieParser());


// Todo, turn this into a POST endpoint.
app.get("/introspect", async (req, res) => {

    const data = new URLSearchParams({
        token: SF_ACCESS_TOKEN,
        client_id: SF_OAUTH_SESSION_CLIENT_ID,
        client_secret: SF_OAUTH_SESSION_CLIENT_SECRET,
        token_type_hint: "access_token"
    });

    console.log(data);

    // Exchange authorization code for access token & id_token.
    const resp = await fetch(SF_OAUTH_SESSION_INSTANCE_URL + "/services/oauth2/introspect", {
        method: "POST",
        body: data,
        headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    });

    const access_token_data = await resp.json();
    console.log(access_token_data);
});







app.get("/login", (req, res) => {
    const state = "some_state";
    // const scopes = GOOGLE_OAUTH_SCOPES.join(" ");
    const loginUrl = `${process.env.SF_OAUTH_SESSION_URL}?client_id=${process.env.SF_OAUTH_SESSION_CLIENT_ID}&redirect_uri=${process.env.SF_OAUTH_SESSION_CALLBACK_URL}&response_type=code&state=${state}`;//&scope=${scopes}`;
    res.redirect(loginUrl);
});



app.get("/logout", (req, res) => {

    res.cookie('instanceUrl', '', { expires: new Date(0) }); // Setting expiration to epoch
    res.cookie('accessToken', '', { expires: new Date(0) }); // Setting expiration to epoch
    res.redirect("/");
});




app.get("/oauth/api/request", async (req, res) => {

    console.log(req.query);

    const { code } = req.query;


    const data = new URLSearchParams({
        code,
        client_id: process.env.SF_OAUTH_SESSION_CLIENT_ID,
        client_secret: process.env.SF_OAUTH_SESSION_CLIENT_SECRET,
        redirect_uri: process.env.SF_OAUTH_SESSION_CALLBACK_URL,
        grant_type: "authorization_code"
    });

    console.log(data);

    // Exchange authorization code for access token & id_token.
    const response = await fetch(process.env.SF_OAUTH_SESSION_TOKEN_URL, {
        method: "POST",
        body: data,
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    });

    console.log("Receiving response...");
    const access_token_data = await response.json();
    console.log(access_token_data);


    res.cookie('instanceUrl', access_token_data.instance_url, { maxAge: 86400000 }); // Cookie expires in 24 hours
    res.cookie('accessToken', access_token_data.access_token, { maxAge: 86400000 }); // Cookie expires in 24 hours
    // What is id_token?
    const { id_token } = access_token_data;

    res.redirect("/");
});



async function foobar() {


    const data = new URLSearchParams({
        grant_type: "client_credentials",
        client_id: process.env.SF_OAUTH_APPLICATION_CLIENT_ID,
        client_secret: process.env.SF_OAUTH_APPLICATION_CLIENT_SECRET
    });

    console.log(data);

    // Exchange authorization code for access token & id_token.
    const response = await fetch(process.env.SF_OAUTH_APPLICATION_TOKEN_ENDPOINT, {
        method: "POST",
        body: data,
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        }
    });

    console.log("Receiving client credential response...");

    return await response.json();
}





app.get("/connect", async (req, res) => {


    let token = await foobar();
    console.log(token);

    res.json(token);
});


app.get("/media", async (req, res) => {

    const query = 'SELECT Id, Name, Description__c, Event__c, Event__r.Name, Event__r.Start_Date__c, Speakers__c, ResourceId__c, Date__c, Published__c, IsPublic__c FROM Media__c ORDER BY Event__r.Start_Date__c DESC NULLS LAST';

    let applicationInstanceUrl, applicationAccessToken;

    let applicationTokens = await foobar();
    applicationInstanceUrl = applicationTokens.instance_url;
    applicationAccessToken = applicationTokens.access_token;


    let application = new SalesforceRestApi(applicationInstanceUrl, applicationAccessToken);


    let resp = await application.query(query);

    res.json(resp.records);
});





// Define a route to serve index.html
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});




// Define a route to serve index.html
app.all('/{*any}', (req, res) => {
    res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});




// Start the server
app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});



// https://ocdla--ocdpartial.sandbox.my.site.com/services/oauth2/authorize

