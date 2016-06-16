// Response.swift
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Zewo
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

extension Response {
    public typealias DidUpgrade = (Request, Stream) throws -> Void

    public var didUpgrade: DidUpgrade? {
        get {
            return storage["response-connection-upgrade"] as? DidUpgrade
        }

        set(didUpgrade) {
            storage["response-connection-upgrade"] = didUpgrade
        }
    }
}

extension Response {

    public init(status: Status = .ok, headers: Headers = [:], cookieHeaders: Set<String> = [], body: Data = Data(), didUpgrade: DidUpgrade? = nil) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: cookieHeaders,
            body: .buffer(body)
        )
        
        self.headers["Content-Length"] = body.count.description

        self.didUpgrade = didUpgrade
    }
    
    public init(status: Status = .ok, headers: Headers = [:], cookieHeaders: Set<String> = [], body: (AsyncSendingStream, ((Void) throws -> Void) -> Void) -> Void) {
        self.init(
            version: Version(major: 1, minor: 1),
            status: status,
            headers: headers,
            cookieHeaders: cookieHeaders,
            body: .asyncSender(body)
        )
        
        self.headers["Transfer-Encoding"] = "chunked"
    }
}

extension Response {
    public var statusCode: Int {
        return status.statusCode
    }

    public var reasonPhrase: String {
        return status.reasonPhrase
    }
}

extension Response: CustomStringConvertible {
    public var statusLineDescription: String {
        return "HTTP/1.1 " + statusCode.description + " " + reasonPhrase + "\n"
    }

    public var description: String {
        return statusLineDescription +
            headers.description
    }
}

extension Response: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description + "\n\n" + storageDescription
    }
}
