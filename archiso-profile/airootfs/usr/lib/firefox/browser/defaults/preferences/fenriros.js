// FenrirOS - Fenrir Browser Default Preferences

// Branding
pref("browser.startup.homepage", "https://fenrirlinux.org");
pref("browser.startup.page", 1);

// Privacy
pref("privacy.trackingprotection.enabled", true);
pref("privacy.trackingprotection.socialtracking.enabled", true);
pref("privacy.donottrackheader.enabled", true);
pref("datareporting.healthreport.uploadEnabled", false);
pref("datareporting.policy.dataSubmissionEnabled", false);
pref("toolkit.telemetry.enabled", false);
pref("toolkit.telemetry.unified", false);
pref("toolkit.telemetry.archive.enabled", false);
pref("browser.newtabpage.activity-stream.feeds.telemetry", false);
pref("browser.newtabpage.activity-stream.telemetry", false);
pref("browser.ping-centre.telemetry", false);

// Disable Pocket
pref("extensions.pocket.enabled", false);

// Disable sponsored content
pref("browser.newtabpage.activity-stream.showSponsored", false);
pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
pref("browser.newtabpage.activity-stream.feeds.section.highlights", false);
pref("browser.newtabpage.activity-stream.feeds.snippets", false);

// Performance / Gaming
pref("gfx.webrender.all", true);
pref("media.hardware-video-decoding.enabled", true);
pref("layers.acceleration.enabled", true);
pref("webgl.disabled", false);
pref("webgl.force-enabled", true);

// Clean new tab
pref("browser.newtabpage.enabled", true);
pref("browser.newtabpage.activity-stream.default.sites", "");

// Misc
pref("browser.shell.checkDefaultBrowser", false);
pref("browser.EULA.override", true);
pref("browser.rights.3.shown", true);
