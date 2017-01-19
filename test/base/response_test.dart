import 'dart:io';

import 'package:test/test.dart';
import 'package:aqueduct/aqueduct.dart';

void main() {
  test("Modifying return value from Response.headers changes actual headers", () {
    var response = new Response(0, {}, null);
    response.headers["a"] = "b";

    var headers = response.headers;
    headers["b"] = "c";
    expect(response.headers["a"], "b");
    expect(response.headers["b"], "c");
    expect(response.headers.length, 2);
  });

  test("Headers get lowercased when set in default constructor", () {
    var response = new Response(0, {"AbC" : "b"}, null);
    expect(response.headers["abc"], "b");
    expect(response.headers.length, 1);
  });

  test("Headers get lowercased when set in convenience constructors", () {
    var response = new Response.ok(null, headers: {"ABCe" : "b"});
    expect(response.headers["abce"], "b");
    expect(response.headers.length, 1);

    response = new Response.created("http://redirect.com", headers: {"ABCe" : "b"});
    expect(response.headers["abce"], "b");
    expect(response.headers["location"], "http://redirect.com");
    expect(response.headers.length, 2);
  });

  test("Headers get lowercased when set manually", () {
    var response = new Response(0, {"AbCe" : "b", "XYZ" : "c"}, null);
    response.headers["ABCe"] = "b";
    expect(response.headers["abce"], "b");
    expect(response.headers["xyz"], "c");
    expect(response.headers.length, 2);
  });

  test("Headers get lowercased when set from Map", () {
    var response = new Response(0, {}, null);
    response.headers = {
      "ABCe" : "b",
      "XYZ" : "c"
    };
    expect(response.headers["abce"], "b");
    expect(response.headers["xyz"], "c");
    expect(response.headers.length, 2);
  });

  test("contentType defaults to json", () {
    var response = new Response.ok(null);
    expect(response.contentType, ContentType.JSON);
  });

  test("contentType property overrides any headers", () {
    var response = new Response.ok(null, headers: {
      HttpHeaders.CONTENT_TYPE : "application/xml"
    });
    response.contentType = ContentType.JSON;

    expect(response.contentType, ContentType.JSON);
    response.headers[HttpHeaders.CONTENT_TYPE] = "application/foo";
    expect(response.contentType, ContentType.JSON);
  });

  test("Setting content type as String through headers returns same type from contentType", () {
    var response = new Response.ok(null, headers: {
      HttpHeaders.CONTENT_TYPE : "application/xml"
    });
    expect(response.contentType.primaryType, "application");
    expect(response.contentType.subType, "xml");
  });

  test("Setting content type as ContentType through headers returns same type from contentType", () {
    var response = new Response.ok(null, headers: {
      HttpHeaders.CONTENT_TYPE : new ContentType("application", "xml")
    });
    expect(response.contentType.primaryType, "application");
    expect(response.contentType.subType, "xml");
  });
}