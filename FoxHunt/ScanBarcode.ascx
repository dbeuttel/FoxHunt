<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="ScanBarcode.ascx.cs" Inherits="FoxHunt.ScanBarcode" %>
<style>
    #interactive.viewport {
    position: relative;
}

#interactive.viewport > canvas, #interactive.viewport > video {
    max-width: 100%;
    width: 100%;
}

canvas.drawing, canvas.drawingBuffer {
    position: absolute;
    left: 0;
    top: 0;
}

#result_strip ul.thumbnails > li .thumbnail img {
    max-width: 140px;
}
#result_strip ul.thumbnails > li {
    display: inline-block;
    vertical-align: middle;
    width: 160px;
}
</style> 

      <section id="container" class="container hidden">

          <div class="controls">
              <fieldset class="hidden input-group">
                  <button class="stop">Stop</button>
              </fieldset>
              <fieldset class="reader-config-group">
                  <label class="hidden">
                      <span>Barcode-Type</span>
                      <select name="decoder_readers">
                          <option value="code_39">Code 39</option>
                      </select>
                  </label>
                  <div class="opts">
                  <label>
                      <span>Resolution (width)</span>
                      <select name="input-stream_constraints">
                          <option value="320x240">320px</option>
                          <option value="640x480">640px</option>
                          <option selected="selected" value="800x600">800px</option>
                          <option value="1280x720">1280px</option>
                          <option value="1600x960">1600px</option>
                          <option value="1920x1080">1920px</option>
                      </select>
                  </label>
                  <label>
                      <span>Patch-Size</span>
                      <select name="locator_patch-size">
                          <option value="x-small">x-small</option>
                          <option value="small">small</option>
                          <option selected="selected" value="medium">medium</option>
                          <option value="large">large</option>
                          <option value="x-large">x-large</option>
                      </select>
                  </label>
                  <label>
                      <span>Half-Sample</span>
                      <input type="checkbox" checked="checked" name="locator_half-sample" />
                  </label>
                  <label>
                      <span>Workers</span>
                      <select name="numOfWorkers">
                          <option value="0">0</option>
                          <option selected="selected" value="1">1</option>
                          <option value="2">2</option>
                          <option value="1">1</option>
                          <option value="8">8</option>
                      </select>
                  </label>
                      </div>
                  <label hidden>
                      <span>Camera</span>
                      <select name="input-stream_constraints" id="deviceSelection">
                      </select>
                  </label>
                   <label style="display: none">
                      <span>Zoom</span>
                      <select name="settings_zoom">
                      </select>
                  </label>
                  <label style="display: none">
                      <span>Torch</span>
                      <input type="checkbox" name="settings_torch" />
                  </label>
              </fieldset>
          </div>
                    <div id="interactive" class="viewport"></div>
          <div id="result_strip">
              <ul class="thumbnails"></ul>
              <ul class="collector"></ul>
          </div>

      </section>

      <script>
          
        $(function () {
            $(".opts").hide();
            $(document).keypress(function (e) {
                if (e.which == 13) {
                    $(".opts").fadeIn();
                }
            });
 

        })


       </script>

      <script src="//webrtc.github.io/adapter/adapter-latest.js" type="text/javascript"></script>
      <script src="js/Scanner/quagga.min.js" type="text/javascript"></script>
      <script src="js/Scanner/scanner.js?ver=2" type="text/javascript"></script>

