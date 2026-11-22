// Fenrir Linux - Fenrir Browser default preferences
// Users can still change all of these in about:config.

// Branding
pref("browser.startup.homepage", "https://fenrirlinux.org");
pref("browser.startup.page", 1);
pref("browser.shell.checkDefaultBrowser", false);

// Use the Fenrir theme once it is installed (see assets/firefox-theme).
pref("extensions.activeThemeID", "fenrir-theme@fenrirlinux.org");

// Privacy
pref("privacy.trackingprotection.enabled", true);
pref("privacy.trackingprotection.socialtracking.enabled", true);
pref("datareporting.healthreport.uploadEnabled", false);
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("toolkit.telemetry.enabled", false);
pref("toolkit.telemetry.unified", false);
pref("toolkit.telemetry.archive.enabled", false);
pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
pref("browser.newtabpage.activity-stream.telemetry", false);

// No sponsored content on the new tab page
pref("browser.newtabpage.activity-stream.showSponsored", false);
pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
pref("browser.newtabpage.activity-stream.default.sites", "");

// Hardware video decoding (VA-API) - saves CPU while gaming with a stream open
pref("media.hardware-video-decoding.enabled", true);
