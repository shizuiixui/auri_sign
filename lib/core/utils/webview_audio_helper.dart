import 'package:webview_flutter/webview_flutter.dart';

class WebViewAudioHelper {
  /// Returns the JavaScript code that mutes or unmutes all audio in the webview.
  /// Handles:
  /// - HTMLMediaElement (<audio>, <video>, and new Audio())
  /// - Web Audio API (AudioContext, webkitAudioContext)
  /// - Web app localStorage flags
  /// - Global JavaScript callback hooks if available
  static String getAudioControlScript(bool isSoundEnabled) {
    return """
      (function() {
        var soundEnabled = $isSoundEnabled;
        window.__auriSoundEnabled = soundEnabled;

        // 1. Mute or unmute all current HTMLMediaElements (Audio / Video)
        try {
          var mediaList = document.querySelectorAll('audio, video');
          for (var i = 0; i < mediaList.length; i++) {
            var media = mediaList[i];
            media.muted = !soundEnabled;
            if (!soundEnabled) {
              media.volume = 0;
              try { media.pause(); } catch(e) {}
            } else {
              media.volume = 1;
            }
          }
        } catch(e) {}

        // 2. Monkey-patch HTMLMediaElement.prototype.play
        if (!window.__auriMediaPatched) {
          window.__auriMediaPatched = true;
          try {
            var origPlay = HTMLMediaElement.prototype.play;
            HTMLMediaElement.prototype.play = function() {
              if (window.__auriSoundEnabled === false) {
                this.muted = true;
                this.volume = 0;
                try { this.pause(); } catch(e) {}
                return Promise.resolve();
              }
              return origPlay.apply(this, arguments);
            };
          } catch(e) {}
        }

        // 3. Intercept Web Audio API (AudioContext & webkitAudioContext)
        window.__auriAudioContexts = window.__auriAudioContexts || [];

        if (!window.__auriWebAudioPatched) {
          window.__auriWebAudioPatched = true;
          try {
            var AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (AudioCtx) {
              var OrigAudioContext = AudioCtx;
              function PatchedAudioContext() {
                var ctx = arguments.length > 0 ? new OrigAudioContext(arguments[0]) : new OrigAudioContext();
                window.__auriAudioContexts.push(ctx);
                if (window.__auriSoundEnabled === false) {
                  try { ctx.suspend(); } catch(e) {}
                }
                return ctx;
              }
              PatchedAudioContext.prototype = OrigAudioContext.prototype;
              if (window.AudioContext) window.AudioContext = PatchedAudioContext;
              if (window.webkitAudioContext) window.webkitAudioContext = PatchedAudioContext;
            }
          } catch(e) {}
        }

        // Suspend or resume existing AudioContext instances
        try {
          if (window.__auriAudioContexts && window.__auriAudioContexts.length > 0) {
            for (var j = 0; j < window.__auriAudioContexts.length; j++) {
              var actx = window.__auriAudioContexts[j];
              try {
                if (!soundEnabled) {
                  if (actx.state === 'running') actx.suspend();
                } else {
                  if (actx.state === 'suspended') actx.resume();
                }
              } catch(e) {}
            }
          }
        } catch(e) {}

        // 4. Update localStorage so web apps checking storage detect the preference
        try {
          localStorage.setItem('sound_effects_enabled', soundEnabled ? 'true' : 'false');
          localStorage.setItem('sound_enabled', soundEnabled ? 'true' : 'false');
          localStorage.setItem('isSoundEffectsEnabled', soundEnabled ? 'true' : 'false');
          localStorage.setItem('muted', soundEnabled ? 'false' : 'true');
        } catch(e) {}

        // 5. Notify web app if it exposes a global mute handler
        try {
          if (typeof window.setAppSoundMuted === 'function') {
            window.setAppSoundMuted(!soundEnabled);
          }
          if (typeof window.setSoundEffectsEnabled === 'function') {
            window.setSoundEffectsEnabled(soundEnabled);
          }
        } catch(e) {}
      })();
    """;
  }

  /// Injects the audio control script into the given WebViewController.
  static void applyAudioSetting(WebViewController controller, bool isSoundEnabled) {
    controller.runJavaScript(getAudioControlScript(isSoundEnabled)).catchError((_) {});
  }
}
