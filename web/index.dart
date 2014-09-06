import 'dart:html';
import 'dart:convert';

String demoTemplate = """
  <div class="panel panel-info">
    <div class="panel-heading" style="height:50px">
      <div class="pull-left">
        <h4 style="margin-top:7px;">{{demo.Name}}</h4>
      </div>
      <div class="pull-right">
        <a href="{{demo.TestUrl}}" class="btn btn-success btn-sm" style="width:70px">start</a>
        <a href="{{demo.SourceUrl}}" class="btn btn-danger btn-sm" style="width:70px" target="_blank">source</a>
      </div>
    </div>
    <div class="panel-body">
      {{demo.Description}}
    </div>
  </div>
""";


void main() {

  HttpRequest.getString("index.json").then((jsonText) {
    var json = JSON.decode(jsonText);
    var demoContainer = querySelector("#demoContainer");
    for(var demo in json) {
      String html = demoTemplate;
      html = html.replaceAll("{{demo.Name}}", demo["Name"]);
      html = html.replaceAll("{{demo.TestUrl}}", demo["TestUrl"]);
      html = html.replaceAll("{{demo.SourceUrl}}", demo["SourceUrl"]);
      html = html.replaceAll("{{demo.Description}}", demo["Description"].join(" "));
      demoContainer.appendHtml(html);
    }
  });
}
