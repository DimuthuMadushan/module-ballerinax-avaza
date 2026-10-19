_Author_:  @DimuthuMadushan \
_Created_: 2026/10/19 \
_Updated_: 2026/10/19 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Avaza. 
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/avaza/avaza/v1/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.


1. Update the API Paths
- **Original**: Paths included common prefix `/api` in each endpoint.
- **Updated**: Common prefix removed from endpoints as it is now in the base URL.
- **Reason**: Simplifies API paths and avoids duplication.
<!-- auto-generated -->

2. Authorization Code flow in the security scheme
- **Original**: The `oauth2` security scheme declared only the OAuth 2.0 implicit flow, with no `tokenUrl`.
- **Updated**: The scheme is an authorization code flow (`accessCode`) with `tokenUrl` set to `https://any.avaza.com/oauth2/token`, the token endpoint stated in the API description.
- **Reason**: The implicit flow gives the generated client no way to refresh a token. Changed in the original `docs/spec/openapi.json`.

3. Remove empty `consumes` arrays
- **Original**: 72 operations declared `"consumes": []`.
- **Updated**: The empty `consumes` arrays are removed.
- **Reason**: An empty per-operation array overrides the defaults and degrades the request content type handling. Changed in the original `docs/spec/openapi.json`.

4. Fix the multipart media type of the expense attachment upload
- **Original**: `POST /api/Expense/Attachment` declared the media type `application/form-data`.
- **Updated**: The media type is `multipart/form-data`.
- **Reason**: `application/form-data` is not a valid media type, so the file part was not generated as a multipart body. Changed in the original `docs/spec/openapi.json`.

5. Correct the server URL
- **Original**: After `bal openapi align`, the server URL in `aligned_ballerina_openapi.json` is `https://api.avaza.com//api`.
- **Updated**: The server URL is `https://api.avaza.com/api`.
- **Reason**: The doubled slash is an artefact of folding the `/api` prefix into the server URL. This is a hand edit to the aligned spec and must be re-applied after a re-align.

6. Simplify the API description
- **Original**: `info.description` was a long HTML block covering authentication setup, blog links, support contacts, the Swagger URL and rate limits.
- **Updated**: `info.description` is a short plain-text summary of the API.
- **Reason**: The description becomes the client's doc comment, and the HTML markup and setup prose do not belong there. Changed in the original `docs/spec/openapi.json`.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json --mode client --tags '' --license docs/license.txt -o ballerina --client-methods remote
```

Note: The license year is hardcoded to 2026, change if necessary.
