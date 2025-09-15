// Web-specific video controller
import 'dart:html' as html;

class WebVideoController {
  static void playYoutubeVideo() {
    final iframe = html.document.getElementById("ytplayer") as html.IFrameElement?;
    if (iframe != null) {
      final message = '{"event":"command","func":"playVideo","args":""}';
      iframe.contentWindow?.postMessage(message, '*');
    }
  }

  static void pauseYoutubeVideo() {
    final iframe = html.document.getElementById("ytplayer") as html.IFrameElement?;
    if (iframe != null) {
      final message = '{"event":"command","func":"pauseVideo","args":""}';
      iframe.contentWindow?.postMessage(message, '*');
    }
  }

  static void playCustomVideo() {
    final video = html.document.getElementById("customVideo") as html.VideoElement?;
    if (video != null && video.paused) {
      video.play();
    }
  }

  static void pauseCustomVideo() {
    final video = html.document.getElementById("customVideo") as html.VideoElement?;
    if (video != null && !video.paused) {
      video.pause();
    }
  }
}
