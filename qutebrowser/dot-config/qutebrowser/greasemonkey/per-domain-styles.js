// ==UserScript==
// @name        DomainStyles
// @include     *
// @run-at      document-start
// ==/UserScript==

(function iife_mark_page_domain() {
	'use strict';

	document.addEventListener('readystatechange', function onReadyStateChange() {
		if (document.readyState == 'interactive') {
			const doc = document.documentElement;
			doc.setAttribute('data-page-domain', window.location.host);
            doc.setAttribute('data-page-scheme', window.location.protocol.slice(0, -1));
		}
	});
})();
