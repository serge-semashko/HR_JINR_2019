(function(){var window=this;var e=this,g=function(a){return"string"==typeof a},aa=function(){},ba=function(a){var b=typeof a;if("object"==b)if(a){if(a instanceof Array)return"array";if(a instanceof Object)return b;var c=Object.prototype.toString.call(a);if("[object Window]"==c)return"object";if("[object Array]"==c||"number"==typeof a.length&&"undefined"!=typeof a.splice&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("splice"))return"array";if("[object Function]"==c||"undefined"!=typeof a.call&&"undefined"!=typeof a.propertyIsEnumerable&&!a.propertyIsEnumerable("call"))return"function"}else return"null";else if("function"==b&&"undefined"==typeof a.call)return"object";return b};var ca=function(){var a=h,b=k;if(g(a))return g(b)&&1==b.length?a.indexOf(b,0):-1;for(var c=0;c<a.length;c++)if(c in a&&a[c]===b)return c;return-1},da=function(a,b){for(var c=a.length,d=g(a)?a.split(""):a,f=0;f<c;f++)f in d&&b.call(void 0,d[f],f,a)},ea=function(a){return Array.prototype.concat.apply([],arguments)};var m=function(){this.a="";this.b=fa};m.prototype.s=!0;m.prototype.j=function(){return this.a};var ha=function(a){return a instanceof m&&a.constructor===m&&a.b===fa?a.a:"type_error:TrustedResourceUrl"},fa={},ia=function(a){var b=new m;b.a=a;return b};var t=function(){this.l="";this.A=ja};t.prototype.s=!0;t.prototype.j=function(){return this.l};var ka=/^(?:(?:https?|mailto|ftp):|[^:/?#]*(?:[/?#]|$))/i,ja={},la=function(a){var b=new t;b.l=a;return b};la("about:blank");var u;a:{var ma=e.navigator;if(ma){var na=ma.userAgent;if(na){u=na;break a}}u=""};var oa=function(a){var b=!1,c;return function(){b||(c=a(),b=!0);return c}},pa=function(){var a=aa;return function(){if(a){var b=a;a=null;b()}}};var v=function(a){v[" "](a);return a};v[" "]=aa;var qa=/^[\w+/_-]+[=]{0,2}$/;var ra=function(){if(!e.crypto)return Math.random();try{var a=new Uint32Array(1);e.crypto.getRandomValues(a);return a[0]/65536/65536}catch(b){return Math.random()}},sa=oa(function(){return-1!=u.indexOf("Google Web Preview")||1E-4>Math.random()}),ta=function(){try{a:{var a=e.document.querySelector("script[nonce]");if(a){var b=a.nonce||a.getAttribute("nonce");if(b&&qa.test(b)){var c=b;break a}}c=void 0}return c}catch(d){}};var w=function(){return e.googletag||(e.googletag={})};var x={1:"pagead2.googlesyndication.com",2:"pubads.g.doubleclick.net",3:"securepubads.g.doubleclick.net",173:"pubads.g.doubleclick.net",174:"securepubads.g.doubleclick.net",7:.02,10:0,13:1500,16:0,17:0,20:0,23:.001,24:200,27:.01,28:0,29:.01,33:"pagead2.googlesyndication.com",34:!0,37:.01,38:.001,47:1E-4,53:"",54:0,58:1,60:0,63:0,65:.01,66:1E-5,67:0,68:0,69:.99,71:0,73:0,162:0,163:"",76:"",77:.001,78:0,81:.001,83:1E-4,85:0,89:1,90:0,91:0,96:1,97:0,99:.01,101:0,103:.01,104:"/pagead/js/rum.js",105:0,106:"1-0-15",107:"1-0-15",110:0,113:1,114:1,115:.01,116:.001,117:1,118:1,123:0,120:1,124:.95,121:.01,169:.01,122:.01,125:.01,127:0,129:.01,131:"",156:0,133:0,134:.01,135:.1,137:.001,167:1,138:"",143:.005,168:1E-4,144:.001,187:.001,141:1,157:.01,158:.001,150:".google.ru",153:.25,179:.01,193:1,170:!1,183:0,196:.001,197:.001,152:[],171:.01,172:null,175:"21061441,21061442,21061443,21061444,21061445,21061446,21061447,21061461,21061452,21061453,21061454,21061455",178:.05,182:1E3,188:0,189:.01,191:1512514930353,192:21510956201635,190:0xa781a7496a3,194:1,199:0,180:null,186:.01,195:.2,198:.05,200:.05,201:0};x[6]=function(a,b){try{for(var c=null;c!=a;c=a,a=a.parent)switch(a.location.protocol){case "https:":return!0;case "file:":return!!b;case "http:":return!1}}catch(d){}return!0}(window);x[49]=(new Date).getTime();x[36]=/^true$/.test("false");x[46]=/^true$/.test("false");x[148]=/^true$/.test("false");var y=function(){var a={},b;for(b in x)a[b]=x[b];this.a=a};y.prototype.get=function(a){return this.a[a]};y.prototype.set=function(a,b){this.a[a]=b};y.b=void 0;y.a=function(){return y.b?y.b:y.b=new y};var ua=["21060621","21060622","21060833","21060713"],va=["21061212","21061213","21061214","21061277"],wa=y.a().a,xa=w(),ya=xa._vars_,za;for(za in ya)wa[za]=ya[za];xa._vars_=wa;var Aa=function(){return"179"},Ba=w();Ba.hasOwnProperty("getVersion")||(Ba.getVersion=Aa);var Ca=function(a){this.a=a||e.document||document};Ca.prototype.createElement=function(a){return this.a.createElement(String(a))};Ca.prototype.appendChild=function(a,b){a.appendChild(b)};var Da=function(a,b){a.addEventListener?a.addEventListener("message",b,void 0):a.attachEvent&&a.attachEvent("onmessage",b)};var Fa=function(){var a=e;this.b=a=void 0===a?e:a;this.B="https://securepubads.g.doubleclick.net/static/3p_cookie.html";this.a=2;this.g=[];this.o=!1;a:{var b=[e.top];a=[];for(var c=0,d;d=b[c++];){a.push(d);try{if(d.frames)for(var f=d.frames.length,l=0;l<f&&50>b.length;++l)b.push(d.frames[l])}catch(M){}}b:{try{var n=e.parent;if(n&&n!=e){var p=n;break b}}catch(M){}p=null}(f=p)&&a.unshift(f);a.unshift(e);var q;for(f=0;f<a.length;++f)try{var r=a[f],O=z(r);if(O){this.a=Ea(O);if(2!=this.a)break a;var P;if(P=!q){p=void 0;try{if(p=!!r&&null!=r.location.href)c:{try{v(r.foo);p=!0;break c}catch(M){}p=!1}P=p}catch(M){P=!1}}P&&(q=r)}}catch(M){}this.b=q||this.b}},A=function(a){if(2!=Ga(a)){for(var b=1==Ga(a),c=0;c<a.g.length;c++)try{a.g[c](b)}catch(d){}a.g=[]}},Ha=function(a){var b=z(a.b);b&&2==a.a&&(a.a=Ea(b))},Ga=function(a){Ha(a);return a.a},Ja=function(a){var b=Ia;b.g.push(a);if(2!=b.a)A(b);else if(b.o||(Da(b.b,function(a){var c=z(b.b);if(c&&a.source==c&&2==b.a){switch(a.data){case "3p_cookie_yes":b.a=1;break;case "3p_cookie_no":b.a=0}A(b)}}),b.o=!0),z(b.b))A(b);else{a=(new Ca(b.b.document)).createElement("IFRAME");a.src=b.B;a.name="detect_3p_cookie";a.style.visibility="hidden";a.style.display="none";a.onload=function(){Ha(b);A(b)};try{b.b.document.body.appendChild(a)}catch(c){}}},Ka=function(a,b){try{return!(!a.frames||!a.frames[b])}catch(c){return!1}},z=function(a){return a.frames&&a.frames[v("detect_3p_cookie")]||null},Ea=function(a){return Ka(a,"3p_cookie_yes")?1:Ka(a,"3p_cookie_no")?0:2};var B=null;var La=oa(function(){var a=e.navigator&&e.navigator.userAgent||"";a=a.toLowerCase();return-1!=a.indexOf("firefox/")||-1!=a.indexOf("chrome/")||-1!=a.indexOf("opr/")}),Ma=function(a,b,c){var d="script";d=void 0===d?"":d;var f=a.createElement("link");f.rel="preload";b instanceof m?b=ha(b):b instanceof t?b=b instanceof t&&b.constructor===t&&b.A===ja?b.l:"type_error:SafeUrl":(b instanceof t||(b=b.s?b.j():String(b),ka.test(b)||(b="about:invalid#zClosurez"),b=la(b)),b=b.j());f.href=b;d&&(f.as=d);c&&(f.nonce=c);if(a=a.getElementsByTagName("head")[0])try{a.appendChild(f)}catch(l){}};var Na=/^\.google\.(com?\.)?[a-z]{2,3}$/,Oa=/\.(cn|com\.bi|do|sl|ba|by|ma)$/,Pa=function(a){return Na.test(a)&&!Oa.test(a)},Qa=function(a){return a.replace(/[\W]/g,function(a){return"&#"+a.charCodeAt()+";"})},C=e,Ia,Ra=function(a,b){a="https://"+("adservice"+b+"/adsid/integrator."+a);b=["domain="+encodeURIComponent(e.location.hostname)];D[3]>=+new Date&&b.push("adsid="+encodeURIComponent(D[1]));return a+"?"+b.join("&")},D,E,F=function(){C=e;D=C.googleToken=C.googleToken||{};var a=+new Date;D[1]&&D[3]>a&&0<D[2]||(D[1]="",D[2]=-1,D[3]=-1,D[4]="",D[6]="");E=C.googleIMState=C.googleIMState||{};Pa(E[1])||(E[1]=".google.com");"array"==ba(E[5])||(E[5]=[]);"boolean"==typeof E[6]||(E[6]=!1);"array"==ba(E[7])||(E[7]=[]);"number"==typeof E[8]||(E[8]=0)},Sa=function(a){try{a()}catch(b){e.setTimeout(function(){throw b;},0)}},Ua=function(a){"complete"==e.document.readyState||"loaded"==e.document.readyState||e.currentScript&&e.currentScript.async?Ta(3):a()},Va=0,G={f:function(){return 0<E[8]},m:function(){E[8]++},u:function(){0<E[8]&&E[8]--},v:function(){E[8]=0},c:function(){},w:function(){return!1},i:function(){return E[5]},h:Sa},H={f:function(){return E[6]},m:function(){E[6]=!0},u:function(){E[6]=!1},v:function(){E[6]=!1},c:function(){},w:function(){return".google.com"!=E[1]&&2<++Va},i:function(){return E[7]},h:function(a){Ua(function(){Sa(a)})}},Ta=function(a){if(1E-5>Math.random()){e.google_image_requests||(e.google_image_requests=[]);var b=e.document.createElement("img");b.src="https://pagead2.googlesyndication.com/pagead/gen_204?id=imerr&err="+a;e.google_image_requests.push(b)}};G.c=function(){if(!G.f()){var a=e.document,b=function(b){var c=Ra("js",b),d=ta();Ma(a,c,d);b=a.createElement("script");b.type="text/javascript";d&&(b.nonce=d);b.onerror=function(){return e.processGoogleToken({},2)};c=ia(c);b.src=ha(c);try{(a.head||a.body||a.documentElement).appendChild(b),G.m()}catch(p){}},c=E[1];b(c);".google.com"!=c&&b(".google.com");b={};var d=(b.newToken="FBT",b);e.setTimeout(function(){return e.processGoogleToken(d,1)},1E3)}};H.c=function(){if(!H.f()){var a=e.document,b=Ra("sync.js",E[1]);Ma(a,b);b=Qa(b);var c=v("script"),d="",f=ta();f&&(d='nonce="'+Qa(f)+'"');var l="<"+c+' src="'+b+'" '+d+"></"+c+">"+("<"+c+" "+d+'>processGoogleTokenSync({"newToken":"FBS"},5);</'+c+">");Ua(function(){a.write(l);H.m()})}};var Wa=function(a,b){F();var c=C.googleToken[5]||0;a&&(0!=c||D[3]>=+new Date?b.h(a):(b.i().push(a),b.c()));D[3]>=+new Date&&D[2]>=+new Date||b.c()},Ya=function(a){e.processGoogleToken=e.processGoogleToken||function(a,c){return Xa(G,a,c)};Wa(a,G)},Za=function(a){e.processGoogleTokenSync=e.processGoogleTokenSync||function(a,c){return Xa(H,a,c)};Wa(a,H)},$a=function(a){Ia=Ia||new Fa;Ja(function(b){b&&a()})},Xa=function(a,b,c){b=void 0===b?{}:b;c=void 0===c?0:c;var d=b.newToken||"",f="NT"==d,l=parseInt(b.freshLifetimeSecs||"",10),n=parseInt(b.validLifetimeSecs||"",10);f&&!n&&(n=3600);var p=b["1p_jar"]||"";b=b.pucrd||"";F();1==c?a.v():a.u();if(!d&&a.w())Pa(".google.com")&&(E[1]=".google.com"),a.c();else{var q=C.googleToken=C.googleToken||{},r=0==c&&d&&g(d)&&!f&&"number"==typeof l&&0<l&&"number"==typeof n&&0<n&&g(p);f=f&&!a.f()&&(!(D[3]>=+new Date)||"NT"==D[1]);var O=!(D[3]>=+new Date)&&0!=c;if(r||f||O)f=+new Date,l=f+1E3*l,n=f+1E3*n,Ta(c),q[5]=c,q[1]=d,q[2]=l,q[3]=n,q[4]=p,q[6]=b,F();if(r||!a.f()){c=a.i();for(d=0;d<c.length;d++)a.h(c[d]);c.length=0}}};var ab=function(){var a=I;if(!a.google_ltobserver){var b=new a.PerformanceObserver(function(b){var c=a.google_lt_queue=a.google_lt_queue||[];da(b.getEntries(),function(a){return c.push(a)})});b.observe({entryTypes:["longtask"]});a.google_ltobserver=b}};v("partner.googleadservices.com");var bb=v("www.googletagservices.com"),J=!1,cb=!1,K="",L="",db=y.a().get(46)&&!y.a().get(6);K=db?"http:":"https:";L=y.a().get(db?2:3);var fb=function(){var a=eb.scripts;if(a)for(var b=0;b<a.length;b++){var c=a[b];if(-1<c.src.indexOf(bb+"/tag/js/gpt"))return c}return null},N=function(a,b){if(null===B){B="";try{var c="";try{c=e.top.location.hash}catch(f){c=e.location.hash}if(c){var d=c.match(/\bdeid=([\d,]+)/);B=d?d[1]:""}}catch(f){}}if(c=(c=B)&&c.match(new RegExp("\\b("+a.join("|")+")\\b")))a=c[0];else if(b)a:{b=a.length*b;if(!sa()&&(c=Math.random(),c<b)){c=ra();a=a[Math.floor(c*a.length)];break a}a=null}else a=null;return a};var Q=void 0,R=w(),I=R.fifWin||window;Q=Q||I.document;var gb=[],hb=w();hb.hasOwnProperty("cmd")||(hb.cmd=gb);if(R.evalScripts)R.evalScripts();else{var ib=y.a(),jb=N(va,ib.get(178));jb&&ib.get(152).push(jb);switch(jb){case "21061213":cb=!0;break;case "21061214":J=!0;break;case "21061277":J=cb=!0}var S=y.a().get(138)||N(ua,y.a().get(137))||N(["21061149"],y.a().get(167)),kb=N(["21061560","21061561"],.01),eb=Q,T=N(["21061590","21061591"],.001),U=y.a();T&&("21061591"==T?(U.set(173,bb),U.set(174,bb)):U.set(163,T),U.get(152).push(T));-1!=u.indexOf("Mobile")||y.a().set(194,0);kb&&U.get(152).push(kb);if("21061561"!=kb){var lb=U.get(150);lb&&(F(),Pa(lb)&&(E[1]=lb))}S&&U.set(138,S);U.set(172,eb.currentScript||fb());I.PerformanceObserver&&I.PerformanceLongTaskTiming&&ab();var mb,V=I;V=void 0===V?e:V;var nb=V.performance;if(mb=nb&&nb.now?nb.now():null){var ob={label:"1",type:9,value:mb},pb,qb=I;pb=qb.google_js_reporting_queue=qb.google_js_reporting_queue||[];1024>pb.length&&pb.push(ob)}var rb;var W=y.a(),X=W.get(76);if(X)rb=X;else{var Y=["178","179"],sb=Y[0]||"179",tb="",ub;if(W.get(131))ub="179";else if(1<Y.length){var Z=["21061619","21061620"],h=[""];if(1>=h.length||Z.length!=h.length)h=[];var k=N(ea(Z,h),.1);if(k){W.set(53,k);var vb;vb=0<=ca();W.set(170,vb);vb&&(Z=h);if(k==Z[0]){var wb=Y[Z.length-1];tb="?v="+wb;W.set(163,wb)}else for(var xb=1;xb<Z.length;++xb)if(k==Z[xb]){ub=Y[xb];break}}}X=K+"//"+L+"/gpt/pubads_impl_"+(ub||sb)+".js"+tb;y.a().set(76,X);rb=X}var yb=rb,zb=Q,Ab=zb.currentScript;if(!("complete"==zb.readyState||"loaded"==zb.readyState||Ab&&Ab.async)){var Bb="gpt-impl-"+Math.random();try{var Cb='<script id="'+Bb+'" src="'+yb+'">\x3c/script>';J&&La()&&(Cb+='<link rel="preconnect" href="'+K+"//"+L+'">');Q.write(Cb);R._syncTagged_=!0}catch(a){}if(Q.getElementById(Bb))switch(R._loadStarted_=!0,S){case "21060833":var Db=pa();$a(Db);Za(Db);break;case "21060622":case "21060713":case "21061149":Za(null)}}if(!R._loadStarted_){switch(S){case "21060833":var Eb=pa();$a(Eb);Ya(Eb);break;case "21060622":case "21060713":case "21061149":Ya(null)}cb&&Ma(Q,yb);var Fb=Q.createElement("script");Fb.src=yb;Fb.async=!0;var Gb=Q.head||Q.body||Q.documentElement;Gb.appendChild(Fb);if(J&&La()){var Hb=Q.createElement("link");Hb.rel="preconnect";Hb.href=K+"//"+L;Gb.appendChild(Hb)}R._loadStarted_=!0}};}).call(this.googletag&&googletag.fifWin?googletag.fifWin.parent:this)
