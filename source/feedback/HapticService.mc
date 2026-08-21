using Toybox.Attention as Attention;

// Wraps Attention.vibrate() so callers don't need to know whether
// haptics are supported in the current context (some background
// contexts and simulators do not support it).
module HapticService {

    function reminderVibration() {
        vibrate([
            new Attention.VibeProfile(50, 300),
            new Attention.VibeProfile(0, 150),
            new Attention.VibeProfile(50, 300)
        ]);
    }

    function confirmVibration() {
        vibrate([ new Attention.VibeProfile(30, 150) ]);
    }

    function vibrate(profile) {
        try {
            if (Attention has :vibrate) {
                Attention.vibrate(profile);
            }
        } catch (ex) {
        }
    }

}
