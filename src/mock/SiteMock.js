import HttpMock from "@ocdla/lib-http/HttpMock";
import Url from "@ocdla/lib-http/Url";
import BonIndex from "@local/local/data/books.xml";
import ss1b from "@local/local/data/ss/ss-1b.html";

export default class SiteMock extends HttpMock {
    imports = {
        "/ss/1b": ss1b
    };
    errors = {
        success: false,
        error: "Invalid inputs"
    };

    getResponse(req) {
        let url = new Url(req.url);
        let path = url.getPath();
        return path.includes("index")
            ? new Response(BonIndex, {
                  headers: { "Content-Type": "application/xml" }
              })
            : new Response(this.imports[path]);
    }
}
