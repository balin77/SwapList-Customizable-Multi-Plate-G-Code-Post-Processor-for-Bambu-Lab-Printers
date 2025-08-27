(()=>{var Sn=Object.create;var dt=Object.defineProperty;var Mn=Object.getOwnPropertyDescriptor;var Gn=Object.getOwnPropertyNames;var kn=Object.getPrototypeOf,Pn=Object.prototype.hasOwnProperty;var Ge=(e=>typeof require<"u"?require:typeof Proxy<"u"?new Proxy(e,{get:(s,r)=>(typeof require<"u"?require:s)[r]}):e)(function(e){if(typeof require<"u")return require.apply(this,arguments);throw Error('Dynamic require of "'+e+'" is not supported')});var ft=(e,s)=>()=>(s||e((s={exports:{}}).exports,s),s.exports);var zn=(e,s,r,t)=>{if(s&&typeof s=="object"||typeof s=="function")for(let i of Gn(s))!Pn.call(e,i)&&i!==r&&dt(e,i,{get:()=>s[i],enumerable:!(t=Mn(s,i))||t.enumerable});return e};var ye=(e,s,r)=>(r=e!=null?Sn(kn(e)):{},zn(s||!e||!e.__esModule?dt(r,"default",{value:e,enumerable:!0}):r,e));var be=ft((Mt,He)=>{(function(e){typeof Mt=="object"&&typeof He<"u"?He.exports=e():typeof define=="function"&&define.amd?define([],e):(typeof window<"u"?window:typeof global<"u"?global:typeof self<"u"?self:this).JSZip=e()})(function(){return function e(s,r,t){function i(_,p){if(!r[_]){if(!s[_]){var w=typeof Ge=="function"&&Ge;if(!p&&w)return w(_,!0);if(n)return n(_,!0);var y=new Error("Cannot find module '"+_+"'");throw y.code="MODULE_NOT_FOUND",y}var c=r[_]={exports:{}};s[_][0].call(c.exports,function(v){var m=s[_][1][v];return i(m||v)},c,c.exports,e,s,r,t)}return r[_].exports}for(var n=typeof Ge=="function"&&Ge,l=0;l<t.length;l++)i(t[l]);return i}({1:[function(e,s,r){"use strict";var t=e("./utils"),i=e("./support"),n="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";r.encode=function(l){for(var _,p,w,y,c,v,m,F=[],h=0,E=l.length,g=E,d=t.getTypeOf(l)!=="string";h<l.length;)g=E-h,w=d?(_=l[h++],p=h<E?l[h++]:0,h<E?l[h++]:0):(_=l.charCodeAt(h++),p=h<E?l.charCodeAt(h++):0,h<E?l.charCodeAt(h++):0),y=_>>2,c=(3&_)<<4|p>>4,v=1<g?(15&p)<<2|w>>6:64,m=2<g?63&w:64,F.push(n.charAt(y)+n.charAt(c)+n.charAt(v)+n.charAt(m));return F.join("")},r.decode=function(l){var _,p,w,y,c,v,m=0,F=0,h="data:";if(l.substr(0,h.length)===h)throw new Error("Invalid base64 input, it looks like a data url.");var E,g=3*(l=l.replace(/[^A-Za-z0-9+/=]/g,"")).length/4;if(l.charAt(l.length-1)===n.charAt(64)&&g--,l.charAt(l.length-2)===n.charAt(64)&&g--,g%1!=0)throw new Error("Invalid base64 input, bad content length.");for(E=i.uint8array?new Uint8Array(0|g):new Array(0|g);m<l.length;)_=n.indexOf(l.charAt(m++))<<2|(y=n.indexOf(l.charAt(m++)))>>4,p=(15&y)<<4|(c=n.indexOf(l.charAt(m++)))>>2,w=(3&c)<<6|(v=n.indexOf(l.charAt(m++))),E[F++]=_,c!==64&&(E[F++]=p),v!==64&&(E[F++]=w);return E}},{"./support":30,"./utils":32}],2:[function(e,s,r){"use strict";var t=e("./external"),i=e("./stream/DataWorker"),n=e("./stream/Crc32Probe"),l=e("./stream/DataLengthProbe");function _(p,w,y,c,v){this.compressedSize=p,this.uncompressedSize=w,this.crc32=y,this.compression=c,this.compressedContent=v}_.prototype={getContentWorker:function(){var p=new i(t.Promise.resolve(this.compressedContent)).pipe(this.compression.uncompressWorker()).pipe(new l("data_length")),w=this;return p.on("end",function(){if(this.streamInfo.data_length!==w.uncompressedSize)throw new Error("Bug : uncompressed data size mismatch")}),p},getCompressedWorker:function(){return new i(t.Promise.resolve(this.compressedContent)).withStreamInfo("compressedSize",this.compressedSize).withStreamInfo("uncompressedSize",this.uncompressedSize).withStreamInfo("crc32",this.crc32).withStreamInfo("compression",this.compression)}},_.createWorkerFrom=function(p,w,y){return p.pipe(new n).pipe(new l("uncompressedSize")).pipe(w.compressWorker(y)).pipe(new l("compressedSize")).withStreamInfo("compression",w)},s.exports=_},{"./external":6,"./stream/Crc32Probe":25,"./stream/DataLengthProbe":26,"./stream/DataWorker":27}],3:[function(e,s,r){"use strict";var t=e("./stream/GenericWorker");r.STORE={magic:"\0\0",compressWorker:function(){return new t("STORE compression")},uncompressWorker:function(){return new t("STORE decompression")}},r.DEFLATE=e("./flate")},{"./flate":7,"./stream/GenericWorker":28}],4:[function(e,s,r){"use strict";var t=e("./utils"),i=function(){for(var n,l=[],_=0;_<256;_++){n=_;for(var p=0;p<8;p++)n=1&n?3988292384^n>>>1:n>>>1;l[_]=n}return l}();s.exports=function(n,l){return n!==void 0&&n.length?t.getTypeOf(n)!=="string"?function(_,p,w,y){var c=i,v=y+w;_^=-1;for(var m=y;m<v;m++)_=_>>>8^c[255&(_^p[m])];return-1^_}(0|l,n,n.length,0):function(_,p,w,y){var c=i,v=y+w;_^=-1;for(var m=y;m<v;m++)_=_>>>8^c[255&(_^p.charCodeAt(m))];return-1^_}(0|l,n,n.length,0):0}},{"./utils":32}],5:[function(e,s,r){"use strict";r.base64=!1,r.binary=!1,r.dir=!1,r.createFolders=!0,r.date=null,r.compression=null,r.compressionOptions=null,r.comment=null,r.unixPermissions=null,r.dosPermissions=null},{}],6:[function(e,s,r){"use strict";var t=null;t=typeof Promise<"u"?Promise:e("lie"),s.exports={Promise:t}},{lie:37}],7:[function(e,s,r){"use strict";var t=typeof Uint8Array<"u"&&typeof Uint16Array<"u"&&typeof Uint32Array<"u",i=e("pako"),n=e("./utils"),l=e("./stream/GenericWorker"),_=t?"uint8array":"array";function p(w,y){l.call(this,"FlateWorker/"+w),this._pako=null,this._pakoAction=w,this._pakoOptions=y,this.meta={}}r.magic="\b\0",n.inherits(p,l),p.prototype.processChunk=function(w){this.meta=w.meta,this._pako===null&&this._createPako(),this._pako.push(n.transformTo(_,w.data),!1)},p.prototype.flush=function(){l.prototype.flush.call(this),this._pako===null&&this._createPako(),this._pako.push([],!0)},p.prototype.cleanUp=function(){l.prototype.cleanUp.call(this),this._pako=null},p.prototype._createPako=function(){this._pako=new i[this._pakoAction]({raw:!0,level:this._pakoOptions.level||-1});var w=this;this._pako.onData=function(y){w.push({data:y,meta:w.meta})}},r.compressWorker=function(w){return new p("Deflate",w)},r.uncompressWorker=function(){return new p("Inflate",{})}},{"./stream/GenericWorker":28,"./utils":32,pako:38}],8:[function(e,s,r){"use strict";function t(c,v){var m,F="";for(m=0;m<v;m++)F+=String.fromCharCode(255&c),c>>>=8;return F}function i(c,v,m,F,h,E){var g,d,o=c.file,u=c.compression,b=E!==_.utf8encode,x=n.transformTo("string",E(o.name)),A=n.transformTo("string",_.utf8encode(o.name)),I=o.comment,W=n.transformTo("string",E(I)),G=n.transformTo("string",_.utf8encode(I)),B=A.length!==o.name.length,f=G.length!==I.length,T="",V="",N="",Q=o.dir,Z=o.date,J={crc32:0,compressedSize:0,uncompressedSize:0};v&&!m||(J.crc32=c.crc32,J.compressedSize=c.compressedSize,J.uncompressedSize=c.uncompressedSize);var X=0;v&&(X|=8),b||!B&&!f||(X|=2048);var z=0,H=0;Q&&(z|=16),h==="UNIX"?(H=798,z|=function(O,ie){var ae=O;return O||(ae=ie?16893:33204),(65535&ae)<<16}(o.unixPermissions,Q)):(H=20,z|=function(O){return 63&(O||0)}(o.dosPermissions)),g=Z.getUTCHours(),g<<=6,g|=Z.getUTCMinutes(),g<<=5,g|=Z.getUTCSeconds()/2,d=Z.getUTCFullYear()-1980,d<<=4,d|=Z.getUTCMonth()+1,d<<=5,d|=Z.getUTCDate(),B&&(V=t(1,1)+t(p(x),4)+A,T+="up"+t(V.length,2)+V),f&&(N=t(1,1)+t(p(W),4)+G,T+="uc"+t(N.length,2)+N);var U="";return U+=`
\0`,U+=t(X,2),U+=u.magic,U+=t(g,2),U+=t(d,2),U+=t(J.crc32,4),U+=t(J.compressedSize,4),U+=t(J.uncompressedSize,4),U+=t(x.length,2),U+=t(T.length,2),{fileRecord:w.LOCAL_FILE_HEADER+U+x+T,dirRecord:w.CENTRAL_FILE_HEADER+t(H,2)+U+t(W.length,2)+"\0\0\0\0"+t(z,4)+t(F,4)+x+T+W}}var n=e("../utils"),l=e("../stream/GenericWorker"),_=e("../utf8"),p=e("../crc32"),w=e("../signature");function y(c,v,m,F){l.call(this,"ZipFileWorker"),this.bytesWritten=0,this.zipComment=v,this.zipPlatform=m,this.encodeFileName=F,this.streamFiles=c,this.accumulate=!1,this.contentBuffer=[],this.dirRecords=[],this.currentSourceOffset=0,this.entriesCount=0,this.currentFile=null,this._sources=[]}n.inherits(y,l),y.prototype.push=function(c){var v=c.meta.percent||0,m=this.entriesCount,F=this._sources.length;this.accumulate?this.contentBuffer.push(c):(this.bytesWritten+=c.data.length,l.prototype.push.call(this,{data:c.data,meta:{currentFile:this.currentFile,percent:m?(v+100*(m-F-1))/m:100}}))},y.prototype.openedSource=function(c){this.currentSourceOffset=this.bytesWritten,this.currentFile=c.file.name;var v=this.streamFiles&&!c.file.dir;if(v){var m=i(c,v,!1,this.currentSourceOffset,this.zipPlatform,this.encodeFileName);this.push({data:m.fileRecord,meta:{percent:0}})}else this.accumulate=!0},y.prototype.closedSource=function(c){this.accumulate=!1;var v=this.streamFiles&&!c.file.dir,m=i(c,v,!0,this.currentSourceOffset,this.zipPlatform,this.encodeFileName);if(this.dirRecords.push(m.dirRecord),v)this.push({data:function(F){return w.DATA_DESCRIPTOR+t(F.crc32,4)+t(F.compressedSize,4)+t(F.uncompressedSize,4)}(c),meta:{percent:100}});else for(this.push({data:m.fileRecord,meta:{percent:0}});this.contentBuffer.length;)this.push(this.contentBuffer.shift());this.currentFile=null},y.prototype.flush=function(){for(var c=this.bytesWritten,v=0;v<this.dirRecords.length;v++)this.push({data:this.dirRecords[v],meta:{percent:100}});var m=this.bytesWritten-c,F=function(h,E,g,d,o){var u=n.transformTo("string",o(d));return w.CENTRAL_DIRECTORY_END+"\0\0\0\0"+t(h,2)+t(h,2)+t(E,4)+t(g,4)+t(u.length,2)+u}(this.dirRecords.length,m,c,this.zipComment,this.encodeFileName);this.push({data:F,meta:{percent:100}})},y.prototype.prepareNextSource=function(){this.previous=this._sources.shift(),this.openedSource(this.previous.streamInfo),this.isPaused?this.previous.pause():this.previous.resume()},y.prototype.registerPrevious=function(c){this._sources.push(c);var v=this;return c.on("data",function(m){v.processChunk(m)}),c.on("end",function(){v.closedSource(v.previous.streamInfo),v._sources.length?v.prepareNextSource():v.end()}),c.on("error",function(m){v.error(m)}),this},y.prototype.resume=function(){return!!l.prototype.resume.call(this)&&(!this.previous&&this._sources.length?(this.prepareNextSource(),!0):this.previous||this._sources.length||this.generatedError?void 0:(this.end(),!0))},y.prototype.error=function(c){var v=this._sources;if(!l.prototype.error.call(this,c))return!1;for(var m=0;m<v.length;m++)try{v[m].error(c)}catch{}return!0},y.prototype.lock=function(){l.prototype.lock.call(this);for(var c=this._sources,v=0;v<c.length;v++)c[v].lock()},s.exports=y},{"../crc32":4,"../signature":23,"../stream/GenericWorker":28,"../utf8":31,"../utils":32}],9:[function(e,s,r){"use strict";var t=e("../compressions"),i=e("./ZipFileWorker");r.generateWorker=function(n,l,_){var p=new i(l.streamFiles,_,l.platform,l.encodeFileName),w=0;try{n.forEach(function(y,c){w++;var v=function(E,g){var d=E||g,o=t[d];if(!o)throw new Error(d+" is not a valid compression method !");return o}(c.options.compression,l.compression),m=c.options.compressionOptions||l.compressionOptions||{},F=c.dir,h=c.date;c._compressWorker(v,m).withStreamInfo("file",{name:y,dir:F,date:h,comment:c.comment||"",unixPermissions:c.unixPermissions,dosPermissions:c.dosPermissions}).pipe(p)}),p.entriesCount=w}catch(y){p.error(y)}return p}},{"../compressions":3,"./ZipFileWorker":8}],10:[function(e,s,r){"use strict";function t(){if(!(this instanceof t))return new t;if(arguments.length)throw new Error("The constructor with parameters has been removed in JSZip 3.0, please check the upgrade guide.");this.files=Object.create(null),this.comment=null,this.root="",this.clone=function(){var i=new t;for(var n in this)typeof this[n]!="function"&&(i[n]=this[n]);return i}}(t.prototype=e("./object")).loadAsync=e("./load"),t.support=e("./support"),t.defaults=e("./defaults"),t.version="3.10.1",t.loadAsync=function(i,n){return new t().loadAsync(i,n)},t.external=e("./external"),s.exports=t},{"./defaults":5,"./external":6,"./load":11,"./object":15,"./support":30}],11:[function(e,s,r){"use strict";var t=e("./utils"),i=e("./external"),n=e("./utf8"),l=e("./zipEntries"),_=e("./stream/Crc32Probe"),p=e("./nodejsUtils");function w(y){return new i.Promise(function(c,v){var m=y.decompressed.getContentWorker().pipe(new _);m.on("error",function(F){v(F)}).on("end",function(){m.streamInfo.crc32!==y.decompressed.crc32?v(new Error("Corrupted zip : CRC32 mismatch")):c()}).resume()})}s.exports=function(y,c){var v=this;return c=t.extend(c||{},{base64:!1,checkCRC32:!1,optimizedBinaryString:!1,createFolders:!1,decodeFileName:n.utf8decode}),p.isNode&&p.isStream(y)?i.Promise.reject(new Error("JSZip can't accept a stream when loading a zip file.")):t.prepareContent("the loaded zip file",y,!0,c.optimizedBinaryString,c.base64).then(function(m){var F=new l(c);return F.load(m),F}).then(function(m){var F=[i.Promise.resolve(m)],h=m.files;if(c.checkCRC32)for(var E=0;E<h.length;E++)F.push(w(h[E]));return i.Promise.all(F)}).then(function(m){for(var F=m.shift(),h=F.files,E=0;E<h.length;E++){var g=h[E],d=g.fileNameStr,o=t.resolve(g.fileNameStr);v.file(o,g.decompressed,{binary:!0,optimizedBinaryString:!0,date:g.date,dir:g.dir,comment:g.fileCommentStr.length?g.fileCommentStr:null,unixPermissions:g.unixPermissions,dosPermissions:g.dosPermissions,createFolders:c.createFolders}),g.dir||(v.file(o).unsafeOriginalName=d)}return F.zipComment.length&&(v.comment=F.zipComment),v})}},{"./external":6,"./nodejsUtils":14,"./stream/Crc32Probe":25,"./utf8":31,"./utils":32,"./zipEntries":33}],12:[function(e,s,r){"use strict";var t=e("../utils"),i=e("../stream/GenericWorker");function n(l,_){i.call(this,"Nodejs stream input adapter for "+l),this._upstreamEnded=!1,this._bindStream(_)}t.inherits(n,i),n.prototype._bindStream=function(l){var _=this;(this._stream=l).pause(),l.on("data",function(p){_.push({data:p,meta:{percent:0}})}).on("error",function(p){_.isPaused?this.generatedError=p:_.error(p)}).on("end",function(){_.isPaused?_._upstreamEnded=!0:_.end()})},n.prototype.pause=function(){return!!i.prototype.pause.call(this)&&(this._stream.pause(),!0)},n.prototype.resume=function(){return!!i.prototype.resume.call(this)&&(this._upstreamEnded?this.end():this._stream.resume(),!0)},s.exports=n},{"../stream/GenericWorker":28,"../utils":32}],13:[function(e,s,r){"use strict";var t=e("readable-stream").Readable;function i(n,l,_){t.call(this,l),this._helper=n;var p=this;n.on("data",function(w,y){p.push(w)||p._helper.pause(),_&&_(y)}).on("error",function(w){p.emit("error",w)}).on("end",function(){p.push(null)})}e("../utils").inherits(i,t),i.prototype._read=function(){this._helper.resume()},s.exports=i},{"../utils":32,"readable-stream":16}],14:[function(e,s,r){"use strict";s.exports={isNode:typeof Buffer<"u",newBufferFrom:function(t,i){if(Buffer.from&&Buffer.from!==Uint8Array.from)return Buffer.from(t,i);if(typeof t=="number")throw new Error('The "data" argument must not be a number');return new Buffer(t,i)},allocBuffer:function(t){if(Buffer.alloc)return Buffer.alloc(t);var i=new Buffer(t);return i.fill(0),i},isBuffer:function(t){return Buffer.isBuffer(t)},isStream:function(t){return t&&typeof t.on=="function"&&typeof t.pause=="function"&&typeof t.resume=="function"}}},{}],15:[function(e,s,r){"use strict";function t(o,u,b){var x,A=n.getTypeOf(u),I=n.extend(b||{},p);I.date=I.date||new Date,I.compression!==null&&(I.compression=I.compression.toUpperCase()),typeof I.unixPermissions=="string"&&(I.unixPermissions=parseInt(I.unixPermissions,8)),I.unixPermissions&&16384&I.unixPermissions&&(I.dir=!0),I.dosPermissions&&16&I.dosPermissions&&(I.dir=!0),I.dir&&(o=h(o)),I.createFolders&&(x=F(o))&&E.call(this,x,!0);var W=A==="string"&&I.binary===!1&&I.base64===!1;b&&b.binary!==void 0||(I.binary=!W),(u instanceof w&&u.uncompressedSize===0||I.dir||!u||u.length===0)&&(I.base64=!1,I.binary=!0,u="",I.compression="STORE",A="string");var G=null;G=u instanceof w||u instanceof l?u:v.isNode&&v.isStream(u)?new m(o,u):n.prepareContent(o,u,I.binary,I.optimizedBinaryString,I.base64);var B=new y(o,G,I);this.files[o]=B}var i=e("./utf8"),n=e("./utils"),l=e("./stream/GenericWorker"),_=e("./stream/StreamHelper"),p=e("./defaults"),w=e("./compressedObject"),y=e("./zipObject"),c=e("./generate"),v=e("./nodejsUtils"),m=e("./nodejs/NodejsStreamInputAdapter"),F=function(o){o.slice(-1)==="/"&&(o=o.substring(0,o.length-1));var u=o.lastIndexOf("/");return 0<u?o.substring(0,u):""},h=function(o){return o.slice(-1)!=="/"&&(o+="/"),o},E=function(o,u){return u=u!==void 0?u:p.createFolders,o=h(o),this.files[o]||t.call(this,o,null,{dir:!0,createFolders:u}),this.files[o]};function g(o){return Object.prototype.toString.call(o)==="[object RegExp]"}var d={load:function(){throw new Error("This method has been removed in JSZip 3.0, please check the upgrade guide.")},forEach:function(o){var u,b,x;for(u in this.files)x=this.files[u],(b=u.slice(this.root.length,u.length))&&u.slice(0,this.root.length)===this.root&&o(b,x)},filter:function(o){var u=[];return this.forEach(function(b,x){o(b,x)&&u.push(x)}),u},file:function(o,u,b){if(arguments.length!==1)return o=this.root+o,t.call(this,o,u,b),this;if(g(o)){var x=o;return this.filter(function(I,W){return!W.dir&&x.test(I)})}var A=this.files[this.root+o];return A&&!A.dir?A:null},folder:function(o){if(!o)return this;if(g(o))return this.filter(function(A,I){return I.dir&&o.test(A)});var u=this.root+o,b=E.call(this,u),x=this.clone();return x.root=b.name,x},remove:function(o){o=this.root+o;var u=this.files[o];if(u||(o.slice(-1)!=="/"&&(o+="/"),u=this.files[o]),u&&!u.dir)delete this.files[o];else for(var b=this.filter(function(A,I){return I.name.slice(0,o.length)===o}),x=0;x<b.length;x++)delete this.files[b[x].name];return this},generate:function(){throw new Error("This method has been removed in JSZip 3.0, please check the upgrade guide.")},generateInternalStream:function(o){var u,b={};try{if((b=n.extend(o||{},{streamFiles:!1,compression:"STORE",compressionOptions:null,type:"",platform:"DOS",comment:null,mimeType:"application/zip",encodeFileName:i.utf8encode})).type=b.type.toLowerCase(),b.compression=b.compression.toUpperCase(),b.type==="binarystring"&&(b.type="string"),!b.type)throw new Error("No output type specified.");n.checkSupport(b.type),b.platform!=="darwin"&&b.platform!=="freebsd"&&b.platform!=="linux"&&b.platform!=="sunos"||(b.platform="UNIX"),b.platform==="win32"&&(b.platform="DOS");var x=b.comment||this.comment||"";u=c.generateWorker(this,b,x)}catch(A){(u=new l("error")).error(A)}return new _(u,b.type||"string",b.mimeType)},generateAsync:function(o,u){return this.generateInternalStream(o).accumulate(u)},generateNodeStream:function(o,u){return(o=o||{}).type||(o.type="nodebuffer"),this.generateInternalStream(o).toNodejsStream(u)}};s.exports=d},{"./compressedObject":2,"./defaults":5,"./generate":9,"./nodejs/NodejsStreamInputAdapter":12,"./nodejsUtils":14,"./stream/GenericWorker":28,"./stream/StreamHelper":29,"./utf8":31,"./utils":32,"./zipObject":35}],16:[function(e,s,r){"use strict";s.exports=e("stream")},{stream:void 0}],17:[function(e,s,r){"use strict";var t=e("./DataReader");function i(n){t.call(this,n);for(var l=0;l<this.data.length;l++)n[l]=255&n[l]}e("../utils").inherits(i,t),i.prototype.byteAt=function(n){return this.data[this.zero+n]},i.prototype.lastIndexOfSignature=function(n){for(var l=n.charCodeAt(0),_=n.charCodeAt(1),p=n.charCodeAt(2),w=n.charCodeAt(3),y=this.length-4;0<=y;--y)if(this.data[y]===l&&this.data[y+1]===_&&this.data[y+2]===p&&this.data[y+3]===w)return y-this.zero;return-1},i.prototype.readAndCheckSignature=function(n){var l=n.charCodeAt(0),_=n.charCodeAt(1),p=n.charCodeAt(2),w=n.charCodeAt(3),y=this.readData(4);return l===y[0]&&_===y[1]&&p===y[2]&&w===y[3]},i.prototype.readData=function(n){if(this.checkOffset(n),n===0)return[];var l=this.data.slice(this.zero+this.index,this.zero+this.index+n);return this.index+=n,l},s.exports=i},{"../utils":32,"./DataReader":18}],18:[function(e,s,r){"use strict";var t=e("../utils");function i(n){this.data=n,this.length=n.length,this.index=0,this.zero=0}i.prototype={checkOffset:function(n){this.checkIndex(this.index+n)},checkIndex:function(n){if(this.length<this.zero+n||n<0)throw new Error("End of data reached (data length = "+this.length+", asked index = "+n+"). Corrupted zip ?")},setIndex:function(n){this.checkIndex(n),this.index=n},skip:function(n){this.setIndex(this.index+n)},byteAt:function(){},readInt:function(n){var l,_=0;for(this.checkOffset(n),l=this.index+n-1;l>=this.index;l--)_=(_<<8)+this.byteAt(l);return this.index+=n,_},readString:function(n){return t.transformTo("string",this.readData(n))},readData:function(){},lastIndexOfSignature:function(){},readAndCheckSignature:function(){},readDate:function(){var n=this.readInt(4);return new Date(Date.UTC(1980+(n>>25&127),(n>>21&15)-1,n>>16&31,n>>11&31,n>>5&63,(31&n)<<1))}},s.exports=i},{"../utils":32}],19:[function(e,s,r){"use strict";var t=e("./Uint8ArrayReader");function i(n){t.call(this,n)}e("../utils").inherits(i,t),i.prototype.readData=function(n){this.checkOffset(n);var l=this.data.slice(this.zero+this.index,this.zero+this.index+n);return this.index+=n,l},s.exports=i},{"../utils":32,"./Uint8ArrayReader":21}],20:[function(e,s,r){"use strict";var t=e("./DataReader");function i(n){t.call(this,n)}e("../utils").inherits(i,t),i.prototype.byteAt=function(n){return this.data.charCodeAt(this.zero+n)},i.prototype.lastIndexOfSignature=function(n){return this.data.lastIndexOf(n)-this.zero},i.prototype.readAndCheckSignature=function(n){return n===this.readData(4)},i.prototype.readData=function(n){this.checkOffset(n);var l=this.data.slice(this.zero+this.index,this.zero+this.index+n);return this.index+=n,l},s.exports=i},{"../utils":32,"./DataReader":18}],21:[function(e,s,r){"use strict";var t=e("./ArrayReader");function i(n){t.call(this,n)}e("../utils").inherits(i,t),i.prototype.readData=function(n){if(this.checkOffset(n),n===0)return new Uint8Array(0);var l=this.data.subarray(this.zero+this.index,this.zero+this.index+n);return this.index+=n,l},s.exports=i},{"../utils":32,"./ArrayReader":17}],22:[function(e,s,r){"use strict";var t=e("../utils"),i=e("../support"),n=e("./ArrayReader"),l=e("./StringReader"),_=e("./NodeBufferReader"),p=e("./Uint8ArrayReader");s.exports=function(w){var y=t.getTypeOf(w);return t.checkSupport(y),y!=="string"||i.uint8array?y==="nodebuffer"?new _(w):i.uint8array?new p(t.transformTo("uint8array",w)):new n(t.transformTo("array",w)):new l(w)}},{"../support":30,"../utils":32,"./ArrayReader":17,"./NodeBufferReader":19,"./StringReader":20,"./Uint8ArrayReader":21}],23:[function(e,s,r){"use strict";r.LOCAL_FILE_HEADER="PK",r.CENTRAL_FILE_HEADER="PK",r.CENTRAL_DIRECTORY_END="PK",r.ZIP64_CENTRAL_DIRECTORY_LOCATOR="PK\x07",r.ZIP64_CENTRAL_DIRECTORY_END="PK",r.DATA_DESCRIPTOR="PK\x07\b"},{}],24:[function(e,s,r){"use strict";var t=e("./GenericWorker"),i=e("../utils");function n(l){t.call(this,"ConvertWorker to "+l),this.destType=l}i.inherits(n,t),n.prototype.processChunk=function(l){this.push({data:i.transformTo(this.destType,l.data),meta:l.meta})},s.exports=n},{"../utils":32,"./GenericWorker":28}],25:[function(e,s,r){"use strict";var t=e("./GenericWorker"),i=e("../crc32");function n(){t.call(this,"Crc32Probe"),this.withStreamInfo("crc32",0)}e("../utils").inherits(n,t),n.prototype.processChunk=function(l){this.streamInfo.crc32=i(l.data,this.streamInfo.crc32||0),this.push(l)},s.exports=n},{"../crc32":4,"../utils":32,"./GenericWorker":28}],26:[function(e,s,r){"use strict";var t=e("../utils"),i=e("./GenericWorker");function n(l){i.call(this,"DataLengthProbe for "+l),this.propName=l,this.withStreamInfo(l,0)}t.inherits(n,i),n.prototype.processChunk=function(l){if(l){var _=this.streamInfo[this.propName]||0;this.streamInfo[this.propName]=_+l.data.length}i.prototype.processChunk.call(this,l)},s.exports=n},{"../utils":32,"./GenericWorker":28}],27:[function(e,s,r){"use strict";var t=e("../utils"),i=e("./GenericWorker");function n(l){i.call(this,"DataWorker");var _=this;this.dataIsReady=!1,this.index=0,this.max=0,this.data=null,this.type="",this._tickScheduled=!1,l.then(function(p){_.dataIsReady=!0,_.data=p,_.max=p&&p.length||0,_.type=t.getTypeOf(p),_.isPaused||_._tickAndRepeat()},function(p){_.error(p)})}t.inherits(n,i),n.prototype.cleanUp=function(){i.prototype.cleanUp.call(this),this.data=null},n.prototype.resume=function(){return!!i.prototype.resume.call(this)&&(!this._tickScheduled&&this.dataIsReady&&(this._tickScheduled=!0,t.delay(this._tickAndRepeat,[],this)),!0)},n.prototype._tickAndRepeat=function(){this._tickScheduled=!1,this.isPaused||this.isFinished||(this._tick(),this.isFinished||(t.delay(this._tickAndRepeat,[],this),this._tickScheduled=!0))},n.prototype._tick=function(){if(this.isPaused||this.isFinished)return!1;var l=null,_=Math.min(this.max,this.index+16384);if(this.index>=this.max)return this.end();switch(this.type){case"string":l=this.data.substring(this.index,_);break;case"uint8array":l=this.data.subarray(this.index,_);break;case"array":case"nodebuffer":l=this.data.slice(this.index,_)}return this.index=_,this.push({data:l,meta:{percent:this.max?this.index/this.max*100:0}})},s.exports=n},{"../utils":32,"./GenericWorker":28}],28:[function(e,s,r){"use strict";function t(i){this.name=i||"default",this.streamInfo={},this.generatedError=null,this.extraStreamInfo={},this.isPaused=!0,this.isFinished=!1,this.isLocked=!1,this._listeners={data:[],end:[],error:[]},this.previous=null}t.prototype={push:function(i){this.emit("data",i)},end:function(){if(this.isFinished)return!1;this.flush();try{this.emit("end"),this.cleanUp(),this.isFinished=!0}catch(i){this.emit("error",i)}return!0},error:function(i){return!this.isFinished&&(this.isPaused?this.generatedError=i:(this.isFinished=!0,this.emit("error",i),this.previous&&this.previous.error(i),this.cleanUp()),!0)},on:function(i,n){return this._listeners[i].push(n),this},cleanUp:function(){this.streamInfo=this.generatedError=this.extraStreamInfo=null,this._listeners=[]},emit:function(i,n){if(this._listeners[i])for(var l=0;l<this._listeners[i].length;l++)this._listeners[i][l].call(this,n)},pipe:function(i){return i.registerPrevious(this)},registerPrevious:function(i){if(this.isLocked)throw new Error("The stream '"+this+"' has already been used.");this.streamInfo=i.streamInfo,this.mergeStreamInfo(),this.previous=i;var n=this;return i.on("data",function(l){n.processChunk(l)}),i.on("end",function(){n.end()}),i.on("error",function(l){n.error(l)}),this},pause:function(){return!this.isPaused&&!this.isFinished&&(this.isPaused=!0,this.previous&&this.previous.pause(),!0)},resume:function(){if(!this.isPaused||this.isFinished)return!1;var i=this.isPaused=!1;return this.generatedError&&(this.error(this.generatedError),i=!0),this.previous&&this.previous.resume(),!i},flush:function(){},processChunk:function(i){this.push(i)},withStreamInfo:function(i,n){return this.extraStreamInfo[i]=n,this.mergeStreamInfo(),this},mergeStreamInfo:function(){for(var i in this.extraStreamInfo)Object.prototype.hasOwnProperty.call(this.extraStreamInfo,i)&&(this.streamInfo[i]=this.extraStreamInfo[i])},lock:function(){if(this.isLocked)throw new Error("The stream '"+this+"' has already been used.");this.isLocked=!0,this.previous&&this.previous.lock()},toString:function(){var i="Worker "+this.name;return this.previous?this.previous+" -> "+i:i}},s.exports=t},{}],29:[function(e,s,r){"use strict";var t=e("../utils"),i=e("./ConvertWorker"),n=e("./GenericWorker"),l=e("../base64"),_=e("../support"),p=e("../external"),w=null;if(_.nodestream)try{w=e("../nodejs/NodejsStreamOutputAdapter")}catch{}function y(v,m){return new p.Promise(function(F,h){var E=[],g=v._internalType,d=v._outputType,o=v._mimeType;v.on("data",function(u,b){E.push(u),m&&m(b)}).on("error",function(u){E=[],h(u)}).on("end",function(){try{var u=function(b,x,A){switch(b){case"blob":return t.newBlob(t.transformTo("arraybuffer",x),A);case"base64":return l.encode(x);default:return t.transformTo(b,x)}}(d,function(b,x){var A,I=0,W=null,G=0;for(A=0;A<x.length;A++)G+=x[A].length;switch(b){case"string":return x.join("");case"array":return Array.prototype.concat.apply([],x);case"uint8array":for(W=new Uint8Array(G),A=0;A<x.length;A++)W.set(x[A],I),I+=x[A].length;return W;case"nodebuffer":return Buffer.concat(x);default:throw new Error("concat : unsupported type '"+b+"'")}}(g,E),o);F(u)}catch(b){h(b)}E=[]}).resume()})}function c(v,m,F){var h=m;switch(m){case"blob":case"arraybuffer":h="uint8array";break;case"base64":h="string"}try{this._internalType=h,this._outputType=m,this._mimeType=F,t.checkSupport(h),this._worker=v.pipe(new i(h)),v.lock()}catch(E){this._worker=new n("error"),this._worker.error(E)}}c.prototype={accumulate:function(v){return y(this,v)},on:function(v,m){var F=this;return v==="data"?this._worker.on(v,function(h){m.call(F,h.data,h.meta)}):this._worker.on(v,function(){t.delay(m,arguments,F)}),this},resume:function(){return t.delay(this._worker.resume,[],this._worker),this},pause:function(){return this._worker.pause(),this},toNodejsStream:function(v){if(t.checkSupport("nodestream"),this._outputType!=="nodebuffer")throw new Error(this._outputType+" is not supported by this method");return new w(this,{objectMode:this._outputType!=="nodebuffer"},v)}},s.exports=c},{"../base64":1,"../external":6,"../nodejs/NodejsStreamOutputAdapter":13,"../support":30,"../utils":32,"./ConvertWorker":24,"./GenericWorker":28}],30:[function(e,s,r){"use strict";if(r.base64=!0,r.array=!0,r.string=!0,r.arraybuffer=typeof ArrayBuffer<"u"&&typeof Uint8Array<"u",r.nodebuffer=typeof Buffer<"u",r.uint8array=typeof Uint8Array<"u",typeof ArrayBuffer>"u")r.blob=!1;else{var t=new ArrayBuffer(0);try{r.blob=new Blob([t],{type:"application/zip"}).size===0}catch{try{var i=new(self.BlobBuilder||self.WebKitBlobBuilder||self.MozBlobBuilder||self.MSBlobBuilder);i.append(t),r.blob=i.getBlob("application/zip").size===0}catch{r.blob=!1}}}try{r.nodestream=!!e("readable-stream").Readable}catch{r.nodestream=!1}},{"readable-stream":16}],31:[function(e,s,r){"use strict";for(var t=e("./utils"),i=e("./support"),n=e("./nodejsUtils"),l=e("./stream/GenericWorker"),_=new Array(256),p=0;p<256;p++)_[p]=252<=p?6:248<=p?5:240<=p?4:224<=p?3:192<=p?2:1;_[254]=_[254]=1;function w(){l.call(this,"utf-8 decode"),this.leftOver=null}function y(){l.call(this,"utf-8 encode")}r.utf8encode=function(c){return i.nodebuffer?n.newBufferFrom(c,"utf-8"):function(v){var m,F,h,E,g,d=v.length,o=0;for(E=0;E<d;E++)(64512&(F=v.charCodeAt(E)))==55296&&E+1<d&&(64512&(h=v.charCodeAt(E+1)))==56320&&(F=65536+(F-55296<<10)+(h-56320),E++),o+=F<128?1:F<2048?2:F<65536?3:4;for(m=i.uint8array?new Uint8Array(o):new Array(o),E=g=0;g<o;E++)(64512&(F=v.charCodeAt(E)))==55296&&E+1<d&&(64512&(h=v.charCodeAt(E+1)))==56320&&(F=65536+(F-55296<<10)+(h-56320),E++),F<128?m[g++]=F:(F<2048?m[g++]=192|F>>>6:(F<65536?m[g++]=224|F>>>12:(m[g++]=240|F>>>18,m[g++]=128|F>>>12&63),m[g++]=128|F>>>6&63),m[g++]=128|63&F);return m}(c)},r.utf8decode=function(c){return i.nodebuffer?t.transformTo("nodebuffer",c).toString("utf-8"):function(v){var m,F,h,E,g=v.length,d=new Array(2*g);for(m=F=0;m<g;)if((h=v[m++])<128)d[F++]=h;else if(4<(E=_[h]))d[F++]=65533,m+=E-1;else{for(h&=E===2?31:E===3?15:7;1<E&&m<g;)h=h<<6|63&v[m++],E--;1<E?d[F++]=65533:h<65536?d[F++]=h:(h-=65536,d[F++]=55296|h>>10&1023,d[F++]=56320|1023&h)}return d.length!==F&&(d.subarray?d=d.subarray(0,F):d.length=F),t.applyFromCharCode(d)}(c=t.transformTo(i.uint8array?"uint8array":"array",c))},t.inherits(w,l),w.prototype.processChunk=function(c){var v=t.transformTo(i.uint8array?"uint8array":"array",c.data);if(this.leftOver&&this.leftOver.length){if(i.uint8array){var m=v;(v=new Uint8Array(m.length+this.leftOver.length)).set(this.leftOver,0),v.set(m,this.leftOver.length)}else v=this.leftOver.concat(v);this.leftOver=null}var F=function(E,g){var d;for((g=g||E.length)>E.length&&(g=E.length),d=g-1;0<=d&&(192&E[d])==128;)d--;return d<0||d===0?g:d+_[E[d]]>g?d:g}(v),h=v;F!==v.length&&(i.uint8array?(h=v.subarray(0,F),this.leftOver=v.subarray(F,v.length)):(h=v.slice(0,F),this.leftOver=v.slice(F,v.length))),this.push({data:r.utf8decode(h),meta:c.meta})},w.prototype.flush=function(){this.leftOver&&this.leftOver.length&&(this.push({data:r.utf8decode(this.leftOver),meta:{}}),this.leftOver=null)},r.Utf8DecodeWorker=w,t.inherits(y,l),y.prototype.processChunk=function(c){this.push({data:r.utf8encode(c.data),meta:c.meta})},r.Utf8EncodeWorker=y},{"./nodejsUtils":14,"./stream/GenericWorker":28,"./support":30,"./utils":32}],32:[function(e,s,r){"use strict";var t=e("./support"),i=e("./base64"),n=e("./nodejsUtils"),l=e("./external");function _(m){return m}function p(m,F){for(var h=0;h<m.length;++h)F[h]=255&m.charCodeAt(h);return F}e("setimmediate"),r.newBlob=function(m,F){r.checkSupport("blob");try{return new Blob([m],{type:F})}catch{try{var h=new(self.BlobBuilder||self.WebKitBlobBuilder||self.MozBlobBuilder||self.MSBlobBuilder);return h.append(m),h.getBlob(F)}catch{throw new Error("Bug : can't construct the Blob.")}}};var w={stringifyByChunk:function(m,F,h){var E=[],g=0,d=m.length;if(d<=h)return String.fromCharCode.apply(null,m);for(;g<d;)F==="array"||F==="nodebuffer"?E.push(String.fromCharCode.apply(null,m.slice(g,Math.min(g+h,d)))):E.push(String.fromCharCode.apply(null,m.subarray(g,Math.min(g+h,d)))),g+=h;return E.join("")},stringifyByChar:function(m){for(var F="",h=0;h<m.length;h++)F+=String.fromCharCode(m[h]);return F},applyCanBeUsed:{uint8array:function(){try{return t.uint8array&&String.fromCharCode.apply(null,new Uint8Array(1)).length===1}catch{return!1}}(),nodebuffer:function(){try{return t.nodebuffer&&String.fromCharCode.apply(null,n.allocBuffer(1)).length===1}catch{return!1}}()}};function y(m){var F=65536,h=r.getTypeOf(m),E=!0;if(h==="uint8array"?E=w.applyCanBeUsed.uint8array:h==="nodebuffer"&&(E=w.applyCanBeUsed.nodebuffer),E)for(;1<F;)try{return w.stringifyByChunk(m,h,F)}catch{F=Math.floor(F/2)}return w.stringifyByChar(m)}function c(m,F){for(var h=0;h<m.length;h++)F[h]=m[h];return F}r.applyFromCharCode=y;var v={};v.string={string:_,array:function(m){return p(m,new Array(m.length))},arraybuffer:function(m){return v.string.uint8array(m).buffer},uint8array:function(m){return p(m,new Uint8Array(m.length))},nodebuffer:function(m){return p(m,n.allocBuffer(m.length))}},v.array={string:y,array:_,arraybuffer:function(m){return new Uint8Array(m).buffer},uint8array:function(m){return new Uint8Array(m)},nodebuffer:function(m){return n.newBufferFrom(m)}},v.arraybuffer={string:function(m){return y(new Uint8Array(m))},array:function(m){return c(new Uint8Array(m),new Array(m.byteLength))},arraybuffer:_,uint8array:function(m){return new Uint8Array(m)},nodebuffer:function(m){return n.newBufferFrom(new Uint8Array(m))}},v.uint8array={string:y,array:function(m){return c(m,new Array(m.length))},arraybuffer:function(m){return m.buffer},uint8array:_,nodebuffer:function(m){return n.newBufferFrom(m)}},v.nodebuffer={string:y,array:function(m){return c(m,new Array(m.length))},arraybuffer:function(m){return v.nodebuffer.uint8array(m).buffer},uint8array:function(m){return c(m,new Uint8Array(m.length))},nodebuffer:_},r.transformTo=function(m,F){if(F=F||"",!m)return F;r.checkSupport(m);var h=r.getTypeOf(F);return v[h][m](F)},r.resolve=function(m){for(var F=m.split("/"),h=[],E=0;E<F.length;E++){var g=F[E];g==="."||g===""&&E!==0&&E!==F.length-1||(g===".."?h.pop():h.push(g))}return h.join("/")},r.getTypeOf=function(m){return typeof m=="string"?"string":Object.prototype.toString.call(m)==="[object Array]"?"array":t.nodebuffer&&n.isBuffer(m)?"nodebuffer":t.uint8array&&m instanceof Uint8Array?"uint8array":t.arraybuffer&&m instanceof ArrayBuffer?"arraybuffer":void 0},r.checkSupport=function(m){if(!t[m.toLowerCase()])throw new Error(m+" is not supported by this platform")},r.MAX_VALUE_16BITS=65535,r.MAX_VALUE_32BITS=-1,r.pretty=function(m){var F,h,E="";for(h=0;h<(m||"").length;h++)E+="\\x"+((F=m.charCodeAt(h))<16?"0":"")+F.toString(16).toUpperCase();return E},r.delay=function(m,F,h){setImmediate(function(){m.apply(h||null,F||[])})},r.inherits=function(m,F){function h(){}h.prototype=F.prototype,m.prototype=new h},r.extend=function(){var m,F,h={};for(m=0;m<arguments.length;m++)for(F in arguments[m])Object.prototype.hasOwnProperty.call(arguments[m],F)&&h[F]===void 0&&(h[F]=arguments[m][F]);return h},r.prepareContent=function(m,F,h,E,g){return l.Promise.resolve(F).then(function(d){return t.blob&&(d instanceof Blob||["[object File]","[object Blob]"].indexOf(Object.prototype.toString.call(d))!==-1)&&typeof FileReader<"u"?new l.Promise(function(o,u){var b=new FileReader;b.onload=function(x){o(x.target.result)},b.onerror=function(x){u(x.target.error)},b.readAsArrayBuffer(d)}):d}).then(function(d){var o=r.getTypeOf(d);return o?(o==="arraybuffer"?d=r.transformTo("uint8array",d):o==="string"&&(g?d=i.decode(d):h&&E!==!0&&(d=function(u){return p(u,t.uint8array?new Uint8Array(u.length):new Array(u.length))}(d))),d):l.Promise.reject(new Error("Can't read the data of '"+m+"'. Is it in a supported JavaScript type (String, Blob, ArrayBuffer, etc) ?"))})}},{"./base64":1,"./external":6,"./nodejsUtils":14,"./support":30,setimmediate:54}],33:[function(e,s,r){"use strict";var t=e("./reader/readerFor"),i=e("./utils"),n=e("./signature"),l=e("./zipEntry"),_=e("./support");function p(w){this.files=[],this.loadOptions=w}p.prototype={checkSignature:function(w){if(!this.reader.readAndCheckSignature(w)){this.reader.index-=4;var y=this.reader.readString(4);throw new Error("Corrupted zip or bug: unexpected signature ("+i.pretty(y)+", expected "+i.pretty(w)+")")}},isSignature:function(w,y){var c=this.reader.index;this.reader.setIndex(w);var v=this.reader.readString(4)===y;return this.reader.setIndex(c),v},readBlockEndOfCentral:function(){this.diskNumber=this.reader.readInt(2),this.diskWithCentralDirStart=this.reader.readInt(2),this.centralDirRecordsOnThisDisk=this.reader.readInt(2),this.centralDirRecords=this.reader.readInt(2),this.centralDirSize=this.reader.readInt(4),this.centralDirOffset=this.reader.readInt(4),this.zipCommentLength=this.reader.readInt(2);var w=this.reader.readData(this.zipCommentLength),y=_.uint8array?"uint8array":"array",c=i.transformTo(y,w);this.zipComment=this.loadOptions.decodeFileName(c)},readBlockZip64EndOfCentral:function(){this.zip64EndOfCentralSize=this.reader.readInt(8),this.reader.skip(4),this.diskNumber=this.reader.readInt(4),this.diskWithCentralDirStart=this.reader.readInt(4),this.centralDirRecordsOnThisDisk=this.reader.readInt(8),this.centralDirRecords=this.reader.readInt(8),this.centralDirSize=this.reader.readInt(8),this.centralDirOffset=this.reader.readInt(8),this.zip64ExtensibleData={};for(var w,y,c,v=this.zip64EndOfCentralSize-44;0<v;)w=this.reader.readInt(2),y=this.reader.readInt(4),c=this.reader.readData(y),this.zip64ExtensibleData[w]={id:w,length:y,value:c}},readBlockZip64EndOfCentralLocator:function(){if(this.diskWithZip64CentralDirStart=this.reader.readInt(4),this.relativeOffsetEndOfZip64CentralDir=this.reader.readInt(8),this.disksCount=this.reader.readInt(4),1<this.disksCount)throw new Error("Multi-volumes zip are not supported")},readLocalFiles:function(){var w,y;for(w=0;w<this.files.length;w++)y=this.files[w],this.reader.setIndex(y.localHeaderOffset),this.checkSignature(n.LOCAL_FILE_HEADER),y.readLocalPart(this.reader),y.handleUTF8(),y.processAttributes()},readCentralDir:function(){var w;for(this.reader.setIndex(this.centralDirOffset);this.reader.readAndCheckSignature(n.CENTRAL_FILE_HEADER);)(w=new l({zip64:this.zip64},this.loadOptions)).readCentralPart(this.reader),this.files.push(w);if(this.centralDirRecords!==this.files.length&&this.centralDirRecords!==0&&this.files.length===0)throw new Error("Corrupted zip or bug: expected "+this.centralDirRecords+" records in central dir, got "+this.files.length)},readEndOfCentral:function(){var w=this.reader.lastIndexOfSignature(n.CENTRAL_DIRECTORY_END);if(w<0)throw this.isSignature(0,n.LOCAL_FILE_HEADER)?new Error("Corrupted zip: can't find end of central directory"):new Error("Can't find end of central directory : is this a zip file ? If it is, see https://stuk.github.io/jszip/documentation/howto/read_zip.html");this.reader.setIndex(w);var y=w;if(this.checkSignature(n.CENTRAL_DIRECTORY_END),this.readBlockEndOfCentral(),this.diskNumber===i.MAX_VALUE_16BITS||this.diskWithCentralDirStart===i.MAX_VALUE_16BITS||this.centralDirRecordsOnThisDisk===i.MAX_VALUE_16BITS||this.centralDirRecords===i.MAX_VALUE_16BITS||this.centralDirSize===i.MAX_VALUE_32BITS||this.centralDirOffset===i.MAX_VALUE_32BITS){if(this.zip64=!0,(w=this.reader.lastIndexOfSignature(n.ZIP64_CENTRAL_DIRECTORY_LOCATOR))<0)throw new Error("Corrupted zip: can't find the ZIP64 end of central directory locator");if(this.reader.setIndex(w),this.checkSignature(n.ZIP64_CENTRAL_DIRECTORY_LOCATOR),this.readBlockZip64EndOfCentralLocator(),!this.isSignature(this.relativeOffsetEndOfZip64CentralDir,n.ZIP64_CENTRAL_DIRECTORY_END)&&(this.relativeOffsetEndOfZip64CentralDir=this.reader.lastIndexOfSignature(n.ZIP64_CENTRAL_DIRECTORY_END),this.relativeOffsetEndOfZip64CentralDir<0))throw new Error("Corrupted zip: can't find the ZIP64 end of central directory");this.reader.setIndex(this.relativeOffsetEndOfZip64CentralDir),this.checkSignature(n.ZIP64_CENTRAL_DIRECTORY_END),this.readBlockZip64EndOfCentral()}var c=this.centralDirOffset+this.centralDirSize;this.zip64&&(c+=20,c+=12+this.zip64EndOfCentralSize);var v=y-c;if(0<v)this.isSignature(y,n.CENTRAL_FILE_HEADER)||(this.reader.zero=v);else if(v<0)throw new Error("Corrupted zip: missing "+Math.abs(v)+" bytes.")},prepareReader:function(w){this.reader=t(w)},load:function(w){this.prepareReader(w),this.readEndOfCentral(),this.readCentralDir(),this.readLocalFiles()}},s.exports=p},{"./reader/readerFor":22,"./signature":23,"./support":30,"./utils":32,"./zipEntry":34}],34:[function(e,s,r){"use strict";var t=e("./reader/readerFor"),i=e("./utils"),n=e("./compressedObject"),l=e("./crc32"),_=e("./utf8"),p=e("./compressions"),w=e("./support");function y(c,v){this.options=c,this.loadOptions=v}y.prototype={isEncrypted:function(){return(1&this.bitFlag)==1},useUTF8:function(){return(2048&this.bitFlag)==2048},readLocalPart:function(c){var v,m;if(c.skip(22),this.fileNameLength=c.readInt(2),m=c.readInt(2),this.fileName=c.readData(this.fileNameLength),c.skip(m),this.compressedSize===-1||this.uncompressedSize===-1)throw new Error("Bug or corrupted zip : didn't get enough information from the central directory (compressedSize === -1 || uncompressedSize === -1)");if((v=function(F){for(var h in p)if(Object.prototype.hasOwnProperty.call(p,h)&&p[h].magic===F)return p[h];return null}(this.compressionMethod))===null)throw new Error("Corrupted zip : compression "+i.pretty(this.compressionMethod)+" unknown (inner file : "+i.transformTo("string",this.fileName)+")");this.decompressed=new n(this.compressedSize,this.uncompressedSize,this.crc32,v,c.readData(this.compressedSize))},readCentralPart:function(c){this.versionMadeBy=c.readInt(2),c.skip(2),this.bitFlag=c.readInt(2),this.compressionMethod=c.readString(2),this.date=c.readDate(),this.crc32=c.readInt(4),this.compressedSize=c.readInt(4),this.uncompressedSize=c.readInt(4);var v=c.readInt(2);if(this.extraFieldsLength=c.readInt(2),this.fileCommentLength=c.readInt(2),this.diskNumberStart=c.readInt(2),this.internalFileAttributes=c.readInt(2),this.externalFileAttributes=c.readInt(4),this.localHeaderOffset=c.readInt(4),this.isEncrypted())throw new Error("Encrypted zip are not supported");c.skip(v),this.readExtraFields(c),this.parseZIP64ExtraField(c),this.fileComment=c.readData(this.fileCommentLength)},processAttributes:function(){this.unixPermissions=null,this.dosPermissions=null;var c=this.versionMadeBy>>8;this.dir=!!(16&this.externalFileAttributes),c==0&&(this.dosPermissions=63&this.externalFileAttributes),c==3&&(this.unixPermissions=this.externalFileAttributes>>16&65535),this.dir||this.fileNameStr.slice(-1)!=="/"||(this.dir=!0)},parseZIP64ExtraField:function(){if(this.extraFields[1]){var c=t(this.extraFields[1].value);this.uncompressedSize===i.MAX_VALUE_32BITS&&(this.uncompressedSize=c.readInt(8)),this.compressedSize===i.MAX_VALUE_32BITS&&(this.compressedSize=c.readInt(8)),this.localHeaderOffset===i.MAX_VALUE_32BITS&&(this.localHeaderOffset=c.readInt(8)),this.diskNumberStart===i.MAX_VALUE_32BITS&&(this.diskNumberStart=c.readInt(4))}},readExtraFields:function(c){var v,m,F,h=c.index+this.extraFieldsLength;for(this.extraFields||(this.extraFields={});c.index+4<h;)v=c.readInt(2),m=c.readInt(2),F=c.readData(m),this.extraFields[v]={id:v,length:m,value:F};c.setIndex(h)},handleUTF8:function(){var c=w.uint8array?"uint8array":"array";if(this.useUTF8())this.fileNameStr=_.utf8decode(this.fileName),this.fileCommentStr=_.utf8decode(this.fileComment);else{var v=this.findExtraFieldUnicodePath();if(v!==null)this.fileNameStr=v;else{var m=i.transformTo(c,this.fileName);this.fileNameStr=this.loadOptions.decodeFileName(m)}var F=this.findExtraFieldUnicodeComment();if(F!==null)this.fileCommentStr=F;else{var h=i.transformTo(c,this.fileComment);this.fileCommentStr=this.loadOptions.decodeFileName(h)}}},findExtraFieldUnicodePath:function(){var c=this.extraFields[28789];if(c){var v=t(c.value);return v.readInt(1)!==1||l(this.fileName)!==v.readInt(4)?null:_.utf8decode(v.readData(c.length-5))}return null},findExtraFieldUnicodeComment:function(){var c=this.extraFields[25461];if(c){var v=t(c.value);return v.readInt(1)!==1||l(this.fileComment)!==v.readInt(4)?null:_.utf8decode(v.readData(c.length-5))}return null}},s.exports=y},{"./compressedObject":2,"./compressions":3,"./crc32":4,"./reader/readerFor":22,"./support":30,"./utf8":31,"./utils":32}],35:[function(e,s,r){"use strict";function t(v,m,F){this.name=v,this.dir=F.dir,this.date=F.date,this.comment=F.comment,this.unixPermissions=F.unixPermissions,this.dosPermissions=F.dosPermissions,this._data=m,this._dataBinary=F.binary,this.options={compression:F.compression,compressionOptions:F.compressionOptions}}var i=e("./stream/StreamHelper"),n=e("./stream/DataWorker"),l=e("./utf8"),_=e("./compressedObject"),p=e("./stream/GenericWorker");t.prototype={internalStream:function(v){var m=null,F="string";try{if(!v)throw new Error("No output type specified.");var h=(F=v.toLowerCase())==="string"||F==="text";F!=="binarystring"&&F!=="text"||(F="string"),m=this._decompressWorker();var E=!this._dataBinary;E&&!h&&(m=m.pipe(new l.Utf8EncodeWorker)),!E&&h&&(m=m.pipe(new l.Utf8DecodeWorker))}catch(g){(m=new p("error")).error(g)}return new i(m,F,"")},async:function(v,m){return this.internalStream(v).accumulate(m)},nodeStream:function(v,m){return this.internalStream(v||"nodebuffer").toNodejsStream(m)},_compressWorker:function(v,m){if(this._data instanceof _&&this._data.compression.magic===v.magic)return this._data.getCompressedWorker();var F=this._decompressWorker();return this._dataBinary||(F=F.pipe(new l.Utf8EncodeWorker)),_.createWorkerFrom(F,v,m)},_decompressWorker:function(){return this._data instanceof _?this._data.getContentWorker():this._data instanceof p?this._data:new n(this._data)}};for(var w=["asText","asBinary","asNodeBuffer","asUint8Array","asArrayBuffer"],y=function(){throw new Error("This method has been removed in JSZip 3.0, please check the upgrade guide.")},c=0;c<w.length;c++)t.prototype[w[c]]=y;s.exports=t},{"./compressedObject":2,"./stream/DataWorker":27,"./stream/GenericWorker":28,"./stream/StreamHelper":29,"./utf8":31}],36:[function(e,s,r){(function(t){"use strict";var i,n,l=t.MutationObserver||t.WebKitMutationObserver;if(l){var _=0,p=new l(v),w=t.document.createTextNode("");p.observe(w,{characterData:!0}),i=function(){w.data=_=++_%2}}else if(t.setImmediate||t.MessageChannel===void 0)i="document"in t&&"onreadystatechange"in t.document.createElement("script")?function(){var m=t.document.createElement("script");m.onreadystatechange=function(){v(),m.onreadystatechange=null,m.parentNode.removeChild(m),m=null},t.document.documentElement.appendChild(m)}:function(){setTimeout(v,0)};else{var y=new t.MessageChannel;y.port1.onmessage=v,i=function(){y.port2.postMessage(0)}}var c=[];function v(){var m,F;n=!0;for(var h=c.length;h;){for(F=c,c=[],m=-1;++m<h;)F[m]();h=c.length}n=!1}s.exports=function(m){c.push(m)!==1||n||i()}}).call(this,typeof global<"u"?global:typeof self<"u"?self:typeof window<"u"?window:{})},{}],37:[function(e,s,r){"use strict";var t=e("immediate");function i(){}var n={},l=["REJECTED"],_=["FULFILLED"],p=["PENDING"];function w(h){if(typeof h!="function")throw new TypeError("resolver must be a function");this.state=p,this.queue=[],this.outcome=void 0,h!==i&&m(this,h)}function y(h,E,g){this.promise=h,typeof E=="function"&&(this.onFulfilled=E,this.callFulfilled=this.otherCallFulfilled),typeof g=="function"&&(this.onRejected=g,this.callRejected=this.otherCallRejected)}function c(h,E,g){t(function(){var d;try{d=E(g)}catch(o){return n.reject(h,o)}d===h?n.reject(h,new TypeError("Cannot resolve promise with itself")):n.resolve(h,d)})}function v(h){var E=h&&h.then;if(h&&(typeof h=="object"||typeof h=="function")&&typeof E=="function")return function(){E.apply(h,arguments)}}function m(h,E){var g=!1;function d(b){g||(g=!0,n.reject(h,b))}function o(b){g||(g=!0,n.resolve(h,b))}var u=F(function(){E(o,d)});u.status==="error"&&d(u.value)}function F(h,E){var g={};try{g.value=h(E),g.status="success"}catch(d){g.status="error",g.value=d}return g}(s.exports=w).prototype.finally=function(h){if(typeof h!="function")return this;var E=this.constructor;return this.then(function(g){return E.resolve(h()).then(function(){return g})},function(g){return E.resolve(h()).then(function(){throw g})})},w.prototype.catch=function(h){return this.then(null,h)},w.prototype.then=function(h,E){if(typeof h!="function"&&this.state===_||typeof E!="function"&&this.state===l)return this;var g=new this.constructor(i);return this.state!==p?c(g,this.state===_?h:E,this.outcome):this.queue.push(new y(g,h,E)),g},y.prototype.callFulfilled=function(h){n.resolve(this.promise,h)},y.prototype.otherCallFulfilled=function(h){c(this.promise,this.onFulfilled,h)},y.prototype.callRejected=function(h){n.reject(this.promise,h)},y.prototype.otherCallRejected=function(h){c(this.promise,this.onRejected,h)},n.resolve=function(h,E){var g=F(v,E);if(g.status==="error")return n.reject(h,g.value);var d=g.value;if(d)m(h,d);else{h.state=_,h.outcome=E;for(var o=-1,u=h.queue.length;++o<u;)h.queue[o].callFulfilled(E)}return h},n.reject=function(h,E){h.state=l,h.outcome=E;for(var g=-1,d=h.queue.length;++g<d;)h.queue[g].callRejected(E);return h},w.resolve=function(h){return h instanceof this?h:n.resolve(new this(i),h)},w.reject=function(h){var E=new this(i);return n.reject(E,h)},w.all=function(h){var E=this;if(Object.prototype.toString.call(h)!=="[object Array]")return this.reject(new TypeError("must be an array"));var g=h.length,d=!1;if(!g)return this.resolve([]);for(var o=new Array(g),u=0,b=-1,x=new this(i);++b<g;)A(h[b],b);return x;function A(I,W){E.resolve(I).then(function(G){o[W]=G,++u!==g||d||(d=!0,n.resolve(x,o))},function(G){d||(d=!0,n.reject(x,G))})}},w.race=function(h){var E=this;if(Object.prototype.toString.call(h)!=="[object Array]")return this.reject(new TypeError("must be an array"));var g=h.length,d=!1;if(!g)return this.resolve([]);for(var o=-1,u=new this(i);++o<g;)b=h[o],E.resolve(b).then(function(x){d||(d=!0,n.resolve(u,x))},function(x){d||(d=!0,n.reject(u,x))});var b;return u}},{immediate:36}],38:[function(e,s,r){"use strict";var t={};(0,e("./lib/utils/common").assign)(t,e("./lib/deflate"),e("./lib/inflate"),e("./lib/zlib/constants")),s.exports=t},{"./lib/deflate":39,"./lib/inflate":40,"./lib/utils/common":41,"./lib/zlib/constants":44}],39:[function(e,s,r){"use strict";var t=e("./zlib/deflate"),i=e("./utils/common"),n=e("./utils/strings"),l=e("./zlib/messages"),_=e("./zlib/zstream"),p=Object.prototype.toString,w=0,y=-1,c=0,v=8;function m(h){if(!(this instanceof m))return new m(h);this.options=i.assign({level:y,method:v,chunkSize:16384,windowBits:15,memLevel:8,strategy:c,to:""},h||{});var E=this.options;E.raw&&0<E.windowBits?E.windowBits=-E.windowBits:E.gzip&&0<E.windowBits&&E.windowBits<16&&(E.windowBits+=16),this.err=0,this.msg="",this.ended=!1,this.chunks=[],this.strm=new _,this.strm.avail_out=0;var g=t.deflateInit2(this.strm,E.level,E.method,E.windowBits,E.memLevel,E.strategy);if(g!==w)throw new Error(l[g]);if(E.header&&t.deflateSetHeader(this.strm,E.header),E.dictionary){var d;if(d=typeof E.dictionary=="string"?n.string2buf(E.dictionary):p.call(E.dictionary)==="[object ArrayBuffer]"?new Uint8Array(E.dictionary):E.dictionary,(g=t.deflateSetDictionary(this.strm,d))!==w)throw new Error(l[g]);this._dict_set=!0}}function F(h,E){var g=new m(E);if(g.push(h,!0),g.err)throw g.msg||l[g.err];return g.result}m.prototype.push=function(h,E){var g,d,o=this.strm,u=this.options.chunkSize;if(this.ended)return!1;d=E===~~E?E:E===!0?4:0,typeof h=="string"?o.input=n.string2buf(h):p.call(h)==="[object ArrayBuffer]"?o.input=new Uint8Array(h):o.input=h,o.next_in=0,o.avail_in=o.input.length;do{if(o.avail_out===0&&(o.output=new i.Buf8(u),o.next_out=0,o.avail_out=u),(g=t.deflate(o,d))!==1&&g!==w)return this.onEnd(g),!(this.ended=!0);o.avail_out!==0&&(o.avail_in!==0||d!==4&&d!==2)||(this.options.to==="string"?this.onData(n.buf2binstring(i.shrinkBuf(o.output,o.next_out))):this.onData(i.shrinkBuf(o.output,o.next_out)))}while((0<o.avail_in||o.avail_out===0)&&g!==1);return d===4?(g=t.deflateEnd(this.strm),this.onEnd(g),this.ended=!0,g===w):d!==2||(this.onEnd(w),!(o.avail_out=0))},m.prototype.onData=function(h){this.chunks.push(h)},m.prototype.onEnd=function(h){h===w&&(this.options.to==="string"?this.result=this.chunks.join(""):this.result=i.flattenChunks(this.chunks)),this.chunks=[],this.err=h,this.msg=this.strm.msg},r.Deflate=m,r.deflate=F,r.deflateRaw=function(h,E){return(E=E||{}).raw=!0,F(h,E)},r.gzip=function(h,E){return(E=E||{}).gzip=!0,F(h,E)}},{"./utils/common":41,"./utils/strings":42,"./zlib/deflate":46,"./zlib/messages":51,"./zlib/zstream":53}],40:[function(e,s,r){"use strict";var t=e("./zlib/inflate"),i=e("./utils/common"),n=e("./utils/strings"),l=e("./zlib/constants"),_=e("./zlib/messages"),p=e("./zlib/zstream"),w=e("./zlib/gzheader"),y=Object.prototype.toString;function c(m){if(!(this instanceof c))return new c(m);this.options=i.assign({chunkSize:16384,windowBits:0,to:""},m||{});var F=this.options;F.raw&&0<=F.windowBits&&F.windowBits<16&&(F.windowBits=-F.windowBits,F.windowBits===0&&(F.windowBits=-15)),!(0<=F.windowBits&&F.windowBits<16)||m&&m.windowBits||(F.windowBits+=32),15<F.windowBits&&F.windowBits<48&&!(15&F.windowBits)&&(F.windowBits|=15),this.err=0,this.msg="",this.ended=!1,this.chunks=[],this.strm=new p,this.strm.avail_out=0;var h=t.inflateInit2(this.strm,F.windowBits);if(h!==l.Z_OK)throw new Error(_[h]);this.header=new w,t.inflateGetHeader(this.strm,this.header)}function v(m,F){var h=new c(F);if(h.push(m,!0),h.err)throw h.msg||_[h.err];return h.result}c.prototype.push=function(m,F){var h,E,g,d,o,u,b=this.strm,x=this.options.chunkSize,A=this.options.dictionary,I=!1;if(this.ended)return!1;E=F===~~F?F:F===!0?l.Z_FINISH:l.Z_NO_FLUSH,typeof m=="string"?b.input=n.binstring2buf(m):y.call(m)==="[object ArrayBuffer]"?b.input=new Uint8Array(m):b.input=m,b.next_in=0,b.avail_in=b.input.length;do{if(b.avail_out===0&&(b.output=new i.Buf8(x),b.next_out=0,b.avail_out=x),(h=t.inflate(b,l.Z_NO_FLUSH))===l.Z_NEED_DICT&&A&&(u=typeof A=="string"?n.string2buf(A):y.call(A)==="[object ArrayBuffer]"?new Uint8Array(A):A,h=t.inflateSetDictionary(this.strm,u)),h===l.Z_BUF_ERROR&&I===!0&&(h=l.Z_OK,I=!1),h!==l.Z_STREAM_END&&h!==l.Z_OK)return this.onEnd(h),!(this.ended=!0);b.next_out&&(b.avail_out!==0&&h!==l.Z_STREAM_END&&(b.avail_in!==0||E!==l.Z_FINISH&&E!==l.Z_SYNC_FLUSH)||(this.options.to==="string"?(g=n.utf8border(b.output,b.next_out),d=b.next_out-g,o=n.buf2string(b.output,g),b.next_out=d,b.avail_out=x-d,d&&i.arraySet(b.output,b.output,g,d,0),this.onData(o)):this.onData(i.shrinkBuf(b.output,b.next_out)))),b.avail_in===0&&b.avail_out===0&&(I=!0)}while((0<b.avail_in||b.avail_out===0)&&h!==l.Z_STREAM_END);return h===l.Z_STREAM_END&&(E=l.Z_FINISH),E===l.Z_FINISH?(h=t.inflateEnd(this.strm),this.onEnd(h),this.ended=!0,h===l.Z_OK):E!==l.Z_SYNC_FLUSH||(this.onEnd(l.Z_OK),!(b.avail_out=0))},c.prototype.onData=function(m){this.chunks.push(m)},c.prototype.onEnd=function(m){m===l.Z_OK&&(this.options.to==="string"?this.result=this.chunks.join(""):this.result=i.flattenChunks(this.chunks)),this.chunks=[],this.err=m,this.msg=this.strm.msg},r.Inflate=c,r.inflate=v,r.inflateRaw=function(m,F){return(F=F||{}).raw=!0,v(m,F)},r.ungzip=v},{"./utils/common":41,"./utils/strings":42,"./zlib/constants":44,"./zlib/gzheader":47,"./zlib/inflate":49,"./zlib/messages":51,"./zlib/zstream":53}],41:[function(e,s,r){"use strict";var t=typeof Uint8Array<"u"&&typeof Uint16Array<"u"&&typeof Int32Array<"u";r.assign=function(l){for(var _=Array.prototype.slice.call(arguments,1);_.length;){var p=_.shift();if(p){if(typeof p!="object")throw new TypeError(p+"must be non-object");for(var w in p)p.hasOwnProperty(w)&&(l[w]=p[w])}}return l},r.shrinkBuf=function(l,_){return l.length===_?l:l.subarray?l.subarray(0,_):(l.length=_,l)};var i={arraySet:function(l,_,p,w,y){if(_.subarray&&l.subarray)l.set(_.subarray(p,p+w),y);else for(var c=0;c<w;c++)l[y+c]=_[p+c]},flattenChunks:function(l){var _,p,w,y,c,v;for(_=w=0,p=l.length;_<p;_++)w+=l[_].length;for(v=new Uint8Array(w),_=y=0,p=l.length;_<p;_++)c=l[_],v.set(c,y),y+=c.length;return v}},n={arraySet:function(l,_,p,w,y){for(var c=0;c<w;c++)l[y+c]=_[p+c]},flattenChunks:function(l){return[].concat.apply([],l)}};r.setTyped=function(l){l?(r.Buf8=Uint8Array,r.Buf16=Uint16Array,r.Buf32=Int32Array,r.assign(r,i)):(r.Buf8=Array,r.Buf16=Array,r.Buf32=Array,r.assign(r,n))},r.setTyped(t)},{}],42:[function(e,s,r){"use strict";var t=e("./common"),i=!0,n=!0;try{String.fromCharCode.apply(null,[0])}catch{i=!1}try{String.fromCharCode.apply(null,new Uint8Array(1))}catch{n=!1}for(var l=new t.Buf8(256),_=0;_<256;_++)l[_]=252<=_?6:248<=_?5:240<=_?4:224<=_?3:192<=_?2:1;function p(w,y){if(y<65537&&(w.subarray&&n||!w.subarray&&i))return String.fromCharCode.apply(null,t.shrinkBuf(w,y));for(var c="",v=0;v<y;v++)c+=String.fromCharCode(w[v]);return c}l[254]=l[254]=1,r.string2buf=function(w){var y,c,v,m,F,h=w.length,E=0;for(m=0;m<h;m++)(64512&(c=w.charCodeAt(m)))==55296&&m+1<h&&(64512&(v=w.charCodeAt(m+1)))==56320&&(c=65536+(c-55296<<10)+(v-56320),m++),E+=c<128?1:c<2048?2:c<65536?3:4;for(y=new t.Buf8(E),m=F=0;F<E;m++)(64512&(c=w.charCodeAt(m)))==55296&&m+1<h&&(64512&(v=w.charCodeAt(m+1)))==56320&&(c=65536+(c-55296<<10)+(v-56320),m++),c<128?y[F++]=c:(c<2048?y[F++]=192|c>>>6:(c<65536?y[F++]=224|c>>>12:(y[F++]=240|c>>>18,y[F++]=128|c>>>12&63),y[F++]=128|c>>>6&63),y[F++]=128|63&c);return y},r.buf2binstring=function(w){return p(w,w.length)},r.binstring2buf=function(w){for(var y=new t.Buf8(w.length),c=0,v=y.length;c<v;c++)y[c]=w.charCodeAt(c);return y},r.buf2string=function(w,y){var c,v,m,F,h=y||w.length,E=new Array(2*h);for(c=v=0;c<h;)if((m=w[c++])<128)E[v++]=m;else if(4<(F=l[m]))E[v++]=65533,c+=F-1;else{for(m&=F===2?31:F===3?15:7;1<F&&c<h;)m=m<<6|63&w[c++],F--;1<F?E[v++]=65533:m<65536?E[v++]=m:(m-=65536,E[v++]=55296|m>>10&1023,E[v++]=56320|1023&m)}return p(E,v)},r.utf8border=function(w,y){var c;for((y=y||w.length)>w.length&&(y=w.length),c=y-1;0<=c&&(192&w[c])==128;)c--;return c<0||c===0?y:c+l[w[c]]>y?c:y}},{"./common":41}],43:[function(e,s,r){"use strict";s.exports=function(t,i,n,l){for(var _=65535&t|0,p=t>>>16&65535|0,w=0;n!==0;){for(n-=w=2e3<n?2e3:n;p=p+(_=_+i[l++]|0)|0,--w;);_%=65521,p%=65521}return _|p<<16|0}},{}],44:[function(e,s,r){"use strict";s.exports={Z_NO_FLUSH:0,Z_PARTIAL_FLUSH:1,Z_SYNC_FLUSH:2,Z_FULL_FLUSH:3,Z_FINISH:4,Z_BLOCK:5,Z_TREES:6,Z_OK:0,Z_STREAM_END:1,Z_NEED_DICT:2,Z_ERRNO:-1,Z_STREAM_ERROR:-2,Z_DATA_ERROR:-3,Z_BUF_ERROR:-5,Z_NO_COMPRESSION:0,Z_BEST_SPEED:1,Z_BEST_COMPRESSION:9,Z_DEFAULT_COMPRESSION:-1,Z_FILTERED:1,Z_HUFFMAN_ONLY:2,Z_RLE:3,Z_FIXED:4,Z_DEFAULT_STRATEGY:0,Z_BINARY:0,Z_TEXT:1,Z_UNKNOWN:2,Z_DEFLATED:8}},{}],45:[function(e,s,r){"use strict";var t=function(){for(var i,n=[],l=0;l<256;l++){i=l;for(var _=0;_<8;_++)i=1&i?3988292384^i>>>1:i>>>1;n[l]=i}return n}();s.exports=function(i,n,l,_){var p=t,w=_+l;i^=-1;for(var y=_;y<w;y++)i=i>>>8^p[255&(i^n[y])];return-1^i}},{}],46:[function(e,s,r){"use strict";var t,i=e("../utils/common"),n=e("./trees"),l=e("./adler32"),_=e("./crc32"),p=e("./messages"),w=0,y=4,c=0,v=-2,m=-1,F=4,h=2,E=8,g=9,d=286,o=30,u=19,b=2*d+1,x=15,A=3,I=258,W=I+A+1,G=42,B=113,f=1,T=2,V=3,N=4;function Q(a,L){return a.msg=p[L],L}function Z(a){return(a<<1)-(4<a?9:0)}function J(a){for(var L=a.length;0<=--L;)a[L]=0}function X(a){var L=a.state,C=L.pending;C>a.avail_out&&(C=a.avail_out),C!==0&&(i.arraySet(a.output,L.pending_buf,L.pending_out,C,a.next_out),a.next_out+=C,L.pending_out+=C,a.total_out+=C,a.avail_out-=C,L.pending-=C,L.pending===0&&(L.pending_out=0))}function z(a,L){n._tr_flush_block(a,0<=a.block_start?a.block_start:-1,a.strstart-a.block_start,L),a.block_start=a.strstart,X(a.strm)}function H(a,L){a.pending_buf[a.pending++]=L}function U(a,L){a.pending_buf[a.pending++]=L>>>8&255,a.pending_buf[a.pending++]=255&L}function O(a,L){var C,M,S=a.max_chain_length,k=a.strstart,R=a.prev_length,D=a.nice_match,P=a.strstart>a.w_size-W?a.strstart-(a.w_size-W):0,j=a.window,q=a.w_mask,Y=a.prev,K=a.strstart+I,re=j[k+R-1],te=j[k+R];a.prev_length>=a.good_match&&(S>>=2),D>a.lookahead&&(D=a.lookahead);do if(j[(C=L)+R]===te&&j[C+R-1]===re&&j[C]===j[k]&&j[++C]===j[k+1]){k+=2,C++;do;while(j[++k]===j[++C]&&j[++k]===j[++C]&&j[++k]===j[++C]&&j[++k]===j[++C]&&j[++k]===j[++C]&&j[++k]===j[++C]&&j[++k]===j[++C]&&j[++k]===j[++C]&&k<K);if(M=I-(K-k),k=K-I,R<M){if(a.match_start=L,D<=(R=M))break;re=j[k+R-1],te=j[k+R]}}while((L=Y[L&q])>P&&--S!=0);return R<=a.lookahead?R:a.lookahead}function ie(a){var L,C,M,S,k,R,D,P,j,q,Y=a.w_size;do{if(S=a.window_size-a.lookahead-a.strstart,a.strstart>=Y+(Y-W)){for(i.arraySet(a.window,a.window,Y,Y,0),a.match_start-=Y,a.strstart-=Y,a.block_start-=Y,L=C=a.hash_size;M=a.head[--L],a.head[L]=Y<=M?M-Y:0,--C;);for(L=C=Y;M=a.prev[--L],a.prev[L]=Y<=M?M-Y:0,--C;);S+=Y}if(a.strm.avail_in===0)break;if(R=a.strm,D=a.window,P=a.strstart+a.lookahead,j=S,q=void 0,q=R.avail_in,j<q&&(q=j),C=q===0?0:(R.avail_in-=q,i.arraySet(D,R.input,R.next_in,q,P),R.state.wrap===1?R.adler=l(R.adler,D,q,P):R.state.wrap===2&&(R.adler=_(R.adler,D,q,P)),R.next_in+=q,R.total_in+=q,q),a.lookahead+=C,a.lookahead+a.insert>=A)for(k=a.strstart-a.insert,a.ins_h=a.window[k],a.ins_h=(a.ins_h<<a.hash_shift^a.window[k+1])&a.hash_mask;a.insert&&(a.ins_h=(a.ins_h<<a.hash_shift^a.window[k+A-1])&a.hash_mask,a.prev[k&a.w_mask]=a.head[a.ins_h],a.head[a.ins_h]=k,k++,a.insert--,!(a.lookahead+a.insert<A)););}while(a.lookahead<W&&a.strm.avail_in!==0)}function ae(a,L){for(var C,M;;){if(a.lookahead<W){if(ie(a),a.lookahead<W&&L===w)return f;if(a.lookahead===0)break}if(C=0,a.lookahead>=A&&(a.ins_h=(a.ins_h<<a.hash_shift^a.window[a.strstart+A-1])&a.hash_mask,C=a.prev[a.strstart&a.w_mask]=a.head[a.ins_h],a.head[a.ins_h]=a.strstart),C!==0&&a.strstart-C<=a.w_size-W&&(a.match_length=O(a,C)),a.match_length>=A)if(M=n._tr_tally(a,a.strstart-a.match_start,a.match_length-A),a.lookahead-=a.match_length,a.match_length<=a.max_lazy_match&&a.lookahead>=A){for(a.match_length--;a.strstart++,a.ins_h=(a.ins_h<<a.hash_shift^a.window[a.strstart+A-1])&a.hash_mask,C=a.prev[a.strstart&a.w_mask]=a.head[a.ins_h],a.head[a.ins_h]=a.strstart,--a.match_length!=0;);a.strstart++}else a.strstart+=a.match_length,a.match_length=0,a.ins_h=a.window[a.strstart],a.ins_h=(a.ins_h<<a.hash_shift^a.window[a.strstart+1])&a.hash_mask;else M=n._tr_tally(a,0,a.window[a.strstart]),a.lookahead--,a.strstart++;if(M&&(z(a,!1),a.strm.avail_out===0))return f}return a.insert=a.strstart<A-1?a.strstart:A-1,L===y?(z(a,!0),a.strm.avail_out===0?V:N):a.last_lit&&(z(a,!1),a.strm.avail_out===0)?f:T}function ee(a,L){for(var C,M,S;;){if(a.lookahead<W){if(ie(a),a.lookahead<W&&L===w)return f;if(a.lookahead===0)break}if(C=0,a.lookahead>=A&&(a.ins_h=(a.ins_h<<a.hash_shift^a.window[a.strstart+A-1])&a.hash_mask,C=a.prev[a.strstart&a.w_mask]=a.head[a.ins_h],a.head[a.ins_h]=a.strstart),a.prev_length=a.match_length,a.prev_match=a.match_start,a.match_length=A-1,C!==0&&a.prev_length<a.max_lazy_match&&a.strstart-C<=a.w_size-W&&(a.match_length=O(a,C),a.match_length<=5&&(a.strategy===1||a.match_length===A&&4096<a.strstart-a.match_start)&&(a.match_length=A-1)),a.prev_length>=A&&a.match_length<=a.prev_length){for(S=a.strstart+a.lookahead-A,M=n._tr_tally(a,a.strstart-1-a.prev_match,a.prev_length-A),a.lookahead-=a.prev_length-1,a.prev_length-=2;++a.strstart<=S&&(a.ins_h=(a.ins_h<<a.hash_shift^a.window[a.strstart+A-1])&a.hash_mask,C=a.prev[a.strstart&a.w_mask]=a.head[a.ins_h],a.head[a.ins_h]=a.strstart),--a.prev_length!=0;);if(a.match_available=0,a.match_length=A-1,a.strstart++,M&&(z(a,!1),a.strm.avail_out===0))return f}else if(a.match_available){if((M=n._tr_tally(a,0,a.window[a.strstart-1]))&&z(a,!1),a.strstart++,a.lookahead--,a.strm.avail_out===0)return f}else a.match_available=1,a.strstart++,a.lookahead--}return a.match_available&&(M=n._tr_tally(a,0,a.window[a.strstart-1]),a.match_available=0),a.insert=a.strstart<A-1?a.strstart:A-1,L===y?(z(a,!0),a.strm.avail_out===0?V:N):a.last_lit&&(z(a,!1),a.strm.avail_out===0)?f:T}function ne(a,L,C,M,S){this.good_length=a,this.max_lazy=L,this.nice_length=C,this.max_chain=M,this.func=S}function oe(){this.strm=null,this.status=0,this.pending_buf=null,this.pending_buf_size=0,this.pending_out=0,this.pending=0,this.wrap=0,this.gzhead=null,this.gzindex=0,this.method=E,this.last_flush=-1,this.w_size=0,this.w_bits=0,this.w_mask=0,this.window=null,this.window_size=0,this.prev=null,this.head=null,this.ins_h=0,this.hash_size=0,this.hash_bits=0,this.hash_mask=0,this.hash_shift=0,this.block_start=0,this.match_length=0,this.prev_match=0,this.match_available=0,this.strstart=0,this.match_start=0,this.lookahead=0,this.prev_length=0,this.max_chain_length=0,this.max_lazy_match=0,this.level=0,this.strategy=0,this.good_match=0,this.nice_match=0,this.dyn_ltree=new i.Buf16(2*b),this.dyn_dtree=new i.Buf16(2*(2*o+1)),this.bl_tree=new i.Buf16(2*(2*u+1)),J(this.dyn_ltree),J(this.dyn_dtree),J(this.bl_tree),this.l_desc=null,this.d_desc=null,this.bl_desc=null,this.bl_count=new i.Buf16(x+1),this.heap=new i.Buf16(2*d+1),J(this.heap),this.heap_len=0,this.heap_max=0,this.depth=new i.Buf16(2*d+1),J(this.depth),this.l_buf=0,this.lit_bufsize=0,this.last_lit=0,this.d_buf=0,this.opt_len=0,this.static_len=0,this.matches=0,this.insert=0,this.bi_buf=0,this.bi_valid=0}function le(a){var L;return a&&a.state?(a.total_in=a.total_out=0,a.data_type=h,(L=a.state).pending=0,L.pending_out=0,L.wrap<0&&(L.wrap=-L.wrap),L.status=L.wrap?G:B,a.adler=L.wrap===2?0:1,L.last_flush=w,n._tr_init(L),c):Q(a,v)}function fe(a){var L=le(a);return L===c&&function(C){C.window_size=2*C.w_size,J(C.head),C.max_lazy_match=t[C.level].max_lazy,C.good_match=t[C.level].good_length,C.nice_match=t[C.level].nice_length,C.max_chain_length=t[C.level].max_chain,C.strstart=0,C.block_start=0,C.lookahead=0,C.insert=0,C.match_length=C.prev_length=A-1,C.match_available=0,C.ins_h=0}(a.state),L}function ue(a,L,C,M,S,k){if(!a)return v;var R=1;if(L===m&&(L=6),M<0?(R=0,M=-M):15<M&&(R=2,M-=16),S<1||g<S||C!==E||M<8||15<M||L<0||9<L||k<0||F<k)return Q(a,v);M===8&&(M=9);var D=new oe;return(a.state=D).strm=a,D.wrap=R,D.gzhead=null,D.w_bits=M,D.w_size=1<<D.w_bits,D.w_mask=D.w_size-1,D.hash_bits=S+7,D.hash_size=1<<D.hash_bits,D.hash_mask=D.hash_size-1,D.hash_shift=~~((D.hash_bits+A-1)/A),D.window=new i.Buf8(2*D.w_size),D.head=new i.Buf16(D.hash_size),D.prev=new i.Buf16(D.w_size),D.lit_bufsize=1<<S+6,D.pending_buf_size=4*D.lit_bufsize,D.pending_buf=new i.Buf8(D.pending_buf_size),D.d_buf=1*D.lit_bufsize,D.l_buf=3*D.lit_bufsize,D.level=L,D.strategy=k,D.method=C,fe(a)}t=[new ne(0,0,0,0,function(a,L){var C=65535;for(C>a.pending_buf_size-5&&(C=a.pending_buf_size-5);;){if(a.lookahead<=1){if(ie(a),a.lookahead===0&&L===w)return f;if(a.lookahead===0)break}a.strstart+=a.lookahead,a.lookahead=0;var M=a.block_start+C;if((a.strstart===0||a.strstart>=M)&&(a.lookahead=a.strstart-M,a.strstart=M,z(a,!1),a.strm.avail_out===0)||a.strstart-a.block_start>=a.w_size-W&&(z(a,!1),a.strm.avail_out===0))return f}return a.insert=0,L===y?(z(a,!0),a.strm.avail_out===0?V:N):(a.strstart>a.block_start&&(z(a,!1),a.strm.avail_out),f)}),new ne(4,4,8,4,ae),new ne(4,5,16,8,ae),new ne(4,6,32,32,ae),new ne(4,4,16,16,ee),new ne(8,16,32,32,ee),new ne(8,16,128,128,ee),new ne(8,32,128,256,ee),new ne(32,128,258,1024,ee),new ne(32,258,258,4096,ee)],r.deflateInit=function(a,L){return ue(a,L,E,15,8,0)},r.deflateInit2=ue,r.deflateReset=fe,r.deflateResetKeep=le,r.deflateSetHeader=function(a,L){return a&&a.state?a.state.wrap!==2?v:(a.state.gzhead=L,c):v},r.deflate=function(a,L){var C,M,S,k;if(!a||!a.state||5<L||L<0)return a?Q(a,v):v;if(M=a.state,!a.output||!a.input&&a.avail_in!==0||M.status===666&&L!==y)return Q(a,a.avail_out===0?-5:v);if(M.strm=a,C=M.last_flush,M.last_flush=L,M.status===G)if(M.wrap===2)a.adler=0,H(M,31),H(M,139),H(M,8),M.gzhead?(H(M,(M.gzhead.text?1:0)+(M.gzhead.hcrc?2:0)+(M.gzhead.extra?4:0)+(M.gzhead.name?8:0)+(M.gzhead.comment?16:0)),H(M,255&M.gzhead.time),H(M,M.gzhead.time>>8&255),H(M,M.gzhead.time>>16&255),H(M,M.gzhead.time>>24&255),H(M,M.level===9?2:2<=M.strategy||M.level<2?4:0),H(M,255&M.gzhead.os),M.gzhead.extra&&M.gzhead.extra.length&&(H(M,255&M.gzhead.extra.length),H(M,M.gzhead.extra.length>>8&255)),M.gzhead.hcrc&&(a.adler=_(a.adler,M.pending_buf,M.pending,0)),M.gzindex=0,M.status=69):(H(M,0),H(M,0),H(M,0),H(M,0),H(M,0),H(M,M.level===9?2:2<=M.strategy||M.level<2?4:0),H(M,3),M.status=B);else{var R=E+(M.w_bits-8<<4)<<8;R|=(2<=M.strategy||M.level<2?0:M.level<6?1:M.level===6?2:3)<<6,M.strstart!==0&&(R|=32),R+=31-R%31,M.status=B,U(M,R),M.strstart!==0&&(U(M,a.adler>>>16),U(M,65535&a.adler)),a.adler=1}if(M.status===69)if(M.gzhead.extra){for(S=M.pending;M.gzindex<(65535&M.gzhead.extra.length)&&(M.pending!==M.pending_buf_size||(M.gzhead.hcrc&&M.pending>S&&(a.adler=_(a.adler,M.pending_buf,M.pending-S,S)),X(a),S=M.pending,M.pending!==M.pending_buf_size));)H(M,255&M.gzhead.extra[M.gzindex]),M.gzindex++;M.gzhead.hcrc&&M.pending>S&&(a.adler=_(a.adler,M.pending_buf,M.pending-S,S)),M.gzindex===M.gzhead.extra.length&&(M.gzindex=0,M.status=73)}else M.status=73;if(M.status===73)if(M.gzhead.name){S=M.pending;do{if(M.pending===M.pending_buf_size&&(M.gzhead.hcrc&&M.pending>S&&(a.adler=_(a.adler,M.pending_buf,M.pending-S,S)),X(a),S=M.pending,M.pending===M.pending_buf_size)){k=1;break}k=M.gzindex<M.gzhead.name.length?255&M.gzhead.name.charCodeAt(M.gzindex++):0,H(M,k)}while(k!==0);M.gzhead.hcrc&&M.pending>S&&(a.adler=_(a.adler,M.pending_buf,M.pending-S,S)),k===0&&(M.gzindex=0,M.status=91)}else M.status=91;if(M.status===91)if(M.gzhead.comment){S=M.pending;do{if(M.pending===M.pending_buf_size&&(M.gzhead.hcrc&&M.pending>S&&(a.adler=_(a.adler,M.pending_buf,M.pending-S,S)),X(a),S=M.pending,M.pending===M.pending_buf_size)){k=1;break}k=M.gzindex<M.gzhead.comment.length?255&M.gzhead.comment.charCodeAt(M.gzindex++):0,H(M,k)}while(k!==0);M.gzhead.hcrc&&M.pending>S&&(a.adler=_(a.adler,M.pending_buf,M.pending-S,S)),k===0&&(M.status=103)}else M.status=103;if(M.status===103&&(M.gzhead.hcrc?(M.pending+2>M.pending_buf_size&&X(a),M.pending+2<=M.pending_buf_size&&(H(M,255&a.adler),H(M,a.adler>>8&255),a.adler=0,M.status=B)):M.status=B),M.pending!==0){if(X(a),a.avail_out===0)return M.last_flush=-1,c}else if(a.avail_in===0&&Z(L)<=Z(C)&&L!==y)return Q(a,-5);if(M.status===666&&a.avail_in!==0)return Q(a,-5);if(a.avail_in!==0||M.lookahead!==0||L!==w&&M.status!==666){var D=M.strategy===2?function(P,j){for(var q;;){if(P.lookahead===0&&(ie(P),P.lookahead===0)){if(j===w)return f;break}if(P.match_length=0,q=n._tr_tally(P,0,P.window[P.strstart]),P.lookahead--,P.strstart++,q&&(z(P,!1),P.strm.avail_out===0))return f}return P.insert=0,j===y?(z(P,!0),P.strm.avail_out===0?V:N):P.last_lit&&(z(P,!1),P.strm.avail_out===0)?f:T}(M,L):M.strategy===3?function(P,j){for(var q,Y,K,re,te=P.window;;){if(P.lookahead<=I){if(ie(P),P.lookahead<=I&&j===w)return f;if(P.lookahead===0)break}if(P.match_length=0,P.lookahead>=A&&0<P.strstart&&(Y=te[K=P.strstart-1])===te[++K]&&Y===te[++K]&&Y===te[++K]){re=P.strstart+I;do;while(Y===te[++K]&&Y===te[++K]&&Y===te[++K]&&Y===te[++K]&&Y===te[++K]&&Y===te[++K]&&Y===te[++K]&&Y===te[++K]&&K<re);P.match_length=I-(re-K),P.match_length>P.lookahead&&(P.match_length=P.lookahead)}if(P.match_length>=A?(q=n._tr_tally(P,1,P.match_length-A),P.lookahead-=P.match_length,P.strstart+=P.match_length,P.match_length=0):(q=n._tr_tally(P,0,P.window[P.strstart]),P.lookahead--,P.strstart++),q&&(z(P,!1),P.strm.avail_out===0))return f}return P.insert=0,j===y?(z(P,!0),P.strm.avail_out===0?V:N):P.last_lit&&(z(P,!1),P.strm.avail_out===0)?f:T}(M,L):t[M.level].func(M,L);if(D!==V&&D!==N||(M.status=666),D===f||D===V)return a.avail_out===0&&(M.last_flush=-1),c;if(D===T&&(L===1?n._tr_align(M):L!==5&&(n._tr_stored_block(M,0,0,!1),L===3&&(J(M.head),M.lookahead===0&&(M.strstart=0,M.block_start=0,M.insert=0))),X(a),a.avail_out===0))return M.last_flush=-1,c}return L!==y?c:M.wrap<=0?1:(M.wrap===2?(H(M,255&a.adler),H(M,a.adler>>8&255),H(M,a.adler>>16&255),H(M,a.adler>>24&255),H(M,255&a.total_in),H(M,a.total_in>>8&255),H(M,a.total_in>>16&255),H(M,a.total_in>>24&255)):(U(M,a.adler>>>16),U(M,65535&a.adler)),X(a),0<M.wrap&&(M.wrap=-M.wrap),M.pending!==0?c:1)},r.deflateEnd=function(a){var L;return a&&a.state?(L=a.state.status)!==G&&L!==69&&L!==73&&L!==91&&L!==103&&L!==B&&L!==666?Q(a,v):(a.state=null,L===B?Q(a,-3):c):v},r.deflateSetDictionary=function(a,L){var C,M,S,k,R,D,P,j,q=L.length;if(!a||!a.state||(k=(C=a.state).wrap)===2||k===1&&C.status!==G||C.lookahead)return v;for(k===1&&(a.adler=l(a.adler,L,q,0)),C.wrap=0,q>=C.w_size&&(k===0&&(J(C.head),C.strstart=0,C.block_start=0,C.insert=0),j=new i.Buf8(C.w_size),i.arraySet(j,L,q-C.w_size,C.w_size,0),L=j,q=C.w_size),R=a.avail_in,D=a.next_in,P=a.input,a.avail_in=q,a.next_in=0,a.input=L,ie(C);C.lookahead>=A;){for(M=C.strstart,S=C.lookahead-(A-1);C.ins_h=(C.ins_h<<C.hash_shift^C.window[M+A-1])&C.hash_mask,C.prev[M&C.w_mask]=C.head[C.ins_h],C.head[C.ins_h]=M,M++,--S;);C.strstart=M,C.lookahead=A-1,ie(C)}return C.strstart+=C.lookahead,C.block_start=C.strstart,C.insert=C.lookahead,C.lookahead=0,C.match_length=C.prev_length=A-1,C.match_available=0,a.next_in=D,a.input=P,a.avail_in=R,C.wrap=k,c},r.deflateInfo="pako deflate (from Nodeca project)"},{"../utils/common":41,"./adler32":43,"./crc32":45,"./messages":51,"./trees":52}],47:[function(e,s,r){"use strict";s.exports=function(){this.text=0,this.time=0,this.xflags=0,this.os=0,this.extra=null,this.extra_len=0,this.name="",this.comment="",this.hcrc=0,this.done=!1}},{}],48:[function(e,s,r){"use strict";s.exports=function(t,i){var n,l,_,p,w,y,c,v,m,F,h,E,g,d,o,u,b,x,A,I,W,G,B,f,T;n=t.state,l=t.next_in,f=t.input,_=l+(t.avail_in-5),p=t.next_out,T=t.output,w=p-(i-t.avail_out),y=p+(t.avail_out-257),c=n.dmax,v=n.wsize,m=n.whave,F=n.wnext,h=n.window,E=n.hold,g=n.bits,d=n.lencode,o=n.distcode,u=(1<<n.lenbits)-1,b=(1<<n.distbits)-1;e:do{g<15&&(E+=f[l++]<<g,g+=8,E+=f[l++]<<g,g+=8),x=d[E&u];t:for(;;){if(E>>>=A=x>>>24,g-=A,(A=x>>>16&255)===0)T[p++]=65535&x;else{if(!(16&A)){if(!(64&A)){x=d[(65535&x)+(E&(1<<A)-1)];continue t}if(32&A){n.mode=12;break e}t.msg="invalid literal/length code",n.mode=30;break e}I=65535&x,(A&=15)&&(g<A&&(E+=f[l++]<<g,g+=8),I+=E&(1<<A)-1,E>>>=A,g-=A),g<15&&(E+=f[l++]<<g,g+=8,E+=f[l++]<<g,g+=8),x=o[E&b];n:for(;;){if(E>>>=A=x>>>24,g-=A,!(16&(A=x>>>16&255))){if(!(64&A)){x=o[(65535&x)+(E&(1<<A)-1)];continue n}t.msg="invalid distance code",n.mode=30;break e}if(W=65535&x,g<(A&=15)&&(E+=f[l++]<<g,(g+=8)<A&&(E+=f[l++]<<g,g+=8)),c<(W+=E&(1<<A)-1)){t.msg="invalid distance too far back",n.mode=30;break e}if(E>>>=A,g-=A,(A=p-w)<W){if(m<(A=W-A)&&n.sane){t.msg="invalid distance too far back",n.mode=30;break e}if(B=h,(G=0)===F){if(G+=v-A,A<I){for(I-=A;T[p++]=h[G++],--A;);G=p-W,B=T}}else if(F<A){if(G+=v+F-A,(A-=F)<I){for(I-=A;T[p++]=h[G++],--A;);if(G=0,F<I){for(I-=A=F;T[p++]=h[G++],--A;);G=p-W,B=T}}}else if(G+=F-A,A<I){for(I-=A;T[p++]=h[G++],--A;);G=p-W,B=T}for(;2<I;)T[p++]=B[G++],T[p++]=B[G++],T[p++]=B[G++],I-=3;I&&(T[p++]=B[G++],1<I&&(T[p++]=B[G++]))}else{for(G=p-W;T[p++]=T[G++],T[p++]=T[G++],T[p++]=T[G++],2<(I-=3););I&&(T[p++]=T[G++],1<I&&(T[p++]=T[G++]))}break}}break}}while(l<_&&p<y);l-=I=g>>3,E&=(1<<(g-=I<<3))-1,t.next_in=l,t.next_out=p,t.avail_in=l<_?_-l+5:5-(l-_),t.avail_out=p<y?y-p+257:257-(p-y),n.hold=E,n.bits=g}},{}],49:[function(e,s,r){"use strict";var t=e("../utils/common"),i=e("./adler32"),n=e("./crc32"),l=e("./inffast"),_=e("./inftrees"),p=1,w=2,y=0,c=-2,v=1,m=852,F=592;function h(G){return(G>>>24&255)+(G>>>8&65280)+((65280&G)<<8)+((255&G)<<24)}function E(){this.mode=0,this.last=!1,this.wrap=0,this.havedict=!1,this.flags=0,this.dmax=0,this.check=0,this.total=0,this.head=null,this.wbits=0,this.wsize=0,this.whave=0,this.wnext=0,this.window=null,this.hold=0,this.bits=0,this.length=0,this.offset=0,this.extra=0,this.lencode=null,this.distcode=null,this.lenbits=0,this.distbits=0,this.ncode=0,this.nlen=0,this.ndist=0,this.have=0,this.next=null,this.lens=new t.Buf16(320),this.work=new t.Buf16(288),this.lendyn=null,this.distdyn=null,this.sane=0,this.back=0,this.was=0}function g(G){var B;return G&&G.state?(B=G.state,G.total_in=G.total_out=B.total=0,G.msg="",B.wrap&&(G.adler=1&B.wrap),B.mode=v,B.last=0,B.havedict=0,B.dmax=32768,B.head=null,B.hold=0,B.bits=0,B.lencode=B.lendyn=new t.Buf32(m),B.distcode=B.distdyn=new t.Buf32(F),B.sane=1,B.back=-1,y):c}function d(G){var B;return G&&G.state?((B=G.state).wsize=0,B.whave=0,B.wnext=0,g(G)):c}function o(G,B){var f,T;return G&&G.state?(T=G.state,B<0?(f=0,B=-B):(f=1+(B>>4),B<48&&(B&=15)),B&&(B<8||15<B)?c:(T.window!==null&&T.wbits!==B&&(T.window=null),T.wrap=f,T.wbits=B,d(G))):c}function u(G,B){var f,T;return G?(T=new E,(G.state=T).window=null,(f=o(G,B))!==y&&(G.state=null),f):c}var b,x,A=!0;function I(G){if(A){var B;for(b=new t.Buf32(512),x=new t.Buf32(32),B=0;B<144;)G.lens[B++]=8;for(;B<256;)G.lens[B++]=9;for(;B<280;)G.lens[B++]=7;for(;B<288;)G.lens[B++]=8;for(_(p,G.lens,0,288,b,0,G.work,{bits:9}),B=0;B<32;)G.lens[B++]=5;_(w,G.lens,0,32,x,0,G.work,{bits:5}),A=!1}G.lencode=b,G.lenbits=9,G.distcode=x,G.distbits=5}function W(G,B,f,T){var V,N=G.state;return N.window===null&&(N.wsize=1<<N.wbits,N.wnext=0,N.whave=0,N.window=new t.Buf8(N.wsize)),T>=N.wsize?(t.arraySet(N.window,B,f-N.wsize,N.wsize,0),N.wnext=0,N.whave=N.wsize):(T<(V=N.wsize-N.wnext)&&(V=T),t.arraySet(N.window,B,f-T,V,N.wnext),(T-=V)?(t.arraySet(N.window,B,f-T,T,0),N.wnext=T,N.whave=N.wsize):(N.wnext+=V,N.wnext===N.wsize&&(N.wnext=0),N.whave<N.wsize&&(N.whave+=V))),0}r.inflateReset=d,r.inflateReset2=o,r.inflateResetKeep=g,r.inflateInit=function(G){return u(G,15)},r.inflateInit2=u,r.inflate=function(G,B){var f,T,V,N,Q,Z,J,X,z,H,U,O,ie,ae,ee,ne,oe,le,fe,ue,a,L,C,M,S=0,k=new t.Buf8(4),R=[16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15];if(!G||!G.state||!G.output||!G.input&&G.avail_in!==0)return c;(f=G.state).mode===12&&(f.mode=13),Q=G.next_out,V=G.output,J=G.avail_out,N=G.next_in,T=G.input,Z=G.avail_in,X=f.hold,z=f.bits,H=Z,U=J,L=y;e:for(;;)switch(f.mode){case v:if(f.wrap===0){f.mode=13;break}for(;z<16;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(2&f.wrap&&X===35615){k[f.check=0]=255&X,k[1]=X>>>8&255,f.check=n(f.check,k,2,0),z=X=0,f.mode=2;break}if(f.flags=0,f.head&&(f.head.done=!1),!(1&f.wrap)||(((255&X)<<8)+(X>>8))%31){G.msg="incorrect header check",f.mode=30;break}if((15&X)!=8){G.msg="unknown compression method",f.mode=30;break}if(z-=4,a=8+(15&(X>>>=4)),f.wbits===0)f.wbits=a;else if(a>f.wbits){G.msg="invalid window size",f.mode=30;break}f.dmax=1<<a,G.adler=f.check=1,f.mode=512&X?10:12,z=X=0;break;case 2:for(;z<16;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(f.flags=X,(255&f.flags)!=8){G.msg="unknown compression method",f.mode=30;break}if(57344&f.flags){G.msg="unknown header flags set",f.mode=30;break}f.head&&(f.head.text=X>>8&1),512&f.flags&&(k[0]=255&X,k[1]=X>>>8&255,f.check=n(f.check,k,2,0)),z=X=0,f.mode=3;case 3:for(;z<32;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}f.head&&(f.head.time=X),512&f.flags&&(k[0]=255&X,k[1]=X>>>8&255,k[2]=X>>>16&255,k[3]=X>>>24&255,f.check=n(f.check,k,4,0)),z=X=0,f.mode=4;case 4:for(;z<16;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}f.head&&(f.head.xflags=255&X,f.head.os=X>>8),512&f.flags&&(k[0]=255&X,k[1]=X>>>8&255,f.check=n(f.check,k,2,0)),z=X=0,f.mode=5;case 5:if(1024&f.flags){for(;z<16;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}f.length=X,f.head&&(f.head.extra_len=X),512&f.flags&&(k[0]=255&X,k[1]=X>>>8&255,f.check=n(f.check,k,2,0)),z=X=0}else f.head&&(f.head.extra=null);f.mode=6;case 6:if(1024&f.flags&&(Z<(O=f.length)&&(O=Z),O&&(f.head&&(a=f.head.extra_len-f.length,f.head.extra||(f.head.extra=new Array(f.head.extra_len)),t.arraySet(f.head.extra,T,N,O,a)),512&f.flags&&(f.check=n(f.check,T,O,N)),Z-=O,N+=O,f.length-=O),f.length))break e;f.length=0,f.mode=7;case 7:if(2048&f.flags){if(Z===0)break e;for(O=0;a=T[N+O++],f.head&&a&&f.length<65536&&(f.head.name+=String.fromCharCode(a)),a&&O<Z;);if(512&f.flags&&(f.check=n(f.check,T,O,N)),Z-=O,N+=O,a)break e}else f.head&&(f.head.name=null);f.length=0,f.mode=8;case 8:if(4096&f.flags){if(Z===0)break e;for(O=0;a=T[N+O++],f.head&&a&&f.length<65536&&(f.head.comment+=String.fromCharCode(a)),a&&O<Z;);if(512&f.flags&&(f.check=n(f.check,T,O,N)),Z-=O,N+=O,a)break e}else f.head&&(f.head.comment=null);f.mode=9;case 9:if(512&f.flags){for(;z<16;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(X!==(65535&f.check)){G.msg="header crc mismatch",f.mode=30;break}z=X=0}f.head&&(f.head.hcrc=f.flags>>9&1,f.head.done=!0),G.adler=f.check=0,f.mode=12;break;case 10:for(;z<32;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}G.adler=f.check=h(X),z=X=0,f.mode=11;case 11:if(f.havedict===0)return G.next_out=Q,G.avail_out=J,G.next_in=N,G.avail_in=Z,f.hold=X,f.bits=z,2;G.adler=f.check=1,f.mode=12;case 12:if(B===5||B===6)break e;case 13:if(f.last){X>>>=7&z,z-=7&z,f.mode=27;break}for(;z<3;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}switch(f.last=1&X,z-=1,3&(X>>>=1)){case 0:f.mode=14;break;case 1:if(I(f),f.mode=20,B!==6)break;X>>>=2,z-=2;break e;case 2:f.mode=17;break;case 3:G.msg="invalid block type",f.mode=30}X>>>=2,z-=2;break;case 14:for(X>>>=7&z,z-=7&z;z<32;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if((65535&X)!=(X>>>16^65535)){G.msg="invalid stored block lengths",f.mode=30;break}if(f.length=65535&X,z=X=0,f.mode=15,B===6)break e;case 15:f.mode=16;case 16:if(O=f.length){if(Z<O&&(O=Z),J<O&&(O=J),O===0)break e;t.arraySet(V,T,N,O,Q),Z-=O,N+=O,J-=O,Q+=O,f.length-=O;break}f.mode=12;break;case 17:for(;z<14;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(f.nlen=257+(31&X),X>>>=5,z-=5,f.ndist=1+(31&X),X>>>=5,z-=5,f.ncode=4+(15&X),X>>>=4,z-=4,286<f.nlen||30<f.ndist){G.msg="too many length or distance symbols",f.mode=30;break}f.have=0,f.mode=18;case 18:for(;f.have<f.ncode;){for(;z<3;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}f.lens[R[f.have++]]=7&X,X>>>=3,z-=3}for(;f.have<19;)f.lens[R[f.have++]]=0;if(f.lencode=f.lendyn,f.lenbits=7,C={bits:f.lenbits},L=_(0,f.lens,0,19,f.lencode,0,f.work,C),f.lenbits=C.bits,L){G.msg="invalid code lengths set",f.mode=30;break}f.have=0,f.mode=19;case 19:for(;f.have<f.nlen+f.ndist;){for(;ne=(S=f.lencode[X&(1<<f.lenbits)-1])>>>16&255,oe=65535&S,!((ee=S>>>24)<=z);){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(oe<16)X>>>=ee,z-=ee,f.lens[f.have++]=oe;else{if(oe===16){for(M=ee+2;z<M;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(X>>>=ee,z-=ee,f.have===0){G.msg="invalid bit length repeat",f.mode=30;break}a=f.lens[f.have-1],O=3+(3&X),X>>>=2,z-=2}else if(oe===17){for(M=ee+3;z<M;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}z-=ee,a=0,O=3+(7&(X>>>=ee)),X>>>=3,z-=3}else{for(M=ee+7;z<M;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}z-=ee,a=0,O=11+(127&(X>>>=ee)),X>>>=7,z-=7}if(f.have+O>f.nlen+f.ndist){G.msg="invalid bit length repeat",f.mode=30;break}for(;O--;)f.lens[f.have++]=a}}if(f.mode===30)break;if(f.lens[256]===0){G.msg="invalid code -- missing end-of-block",f.mode=30;break}if(f.lenbits=9,C={bits:f.lenbits},L=_(p,f.lens,0,f.nlen,f.lencode,0,f.work,C),f.lenbits=C.bits,L){G.msg="invalid literal/lengths set",f.mode=30;break}if(f.distbits=6,f.distcode=f.distdyn,C={bits:f.distbits},L=_(w,f.lens,f.nlen,f.ndist,f.distcode,0,f.work,C),f.distbits=C.bits,L){G.msg="invalid distances set",f.mode=30;break}if(f.mode=20,B===6)break e;case 20:f.mode=21;case 21:if(6<=Z&&258<=J){G.next_out=Q,G.avail_out=J,G.next_in=N,G.avail_in=Z,f.hold=X,f.bits=z,l(G,U),Q=G.next_out,V=G.output,J=G.avail_out,N=G.next_in,T=G.input,Z=G.avail_in,X=f.hold,z=f.bits,f.mode===12&&(f.back=-1);break}for(f.back=0;ne=(S=f.lencode[X&(1<<f.lenbits)-1])>>>16&255,oe=65535&S,!((ee=S>>>24)<=z);){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(ne&&!(240&ne)){for(le=ee,fe=ne,ue=oe;ne=(S=f.lencode[ue+((X&(1<<le+fe)-1)>>le)])>>>16&255,oe=65535&S,!(le+(ee=S>>>24)<=z);){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}X>>>=le,z-=le,f.back+=le}if(X>>>=ee,z-=ee,f.back+=ee,f.length=oe,ne===0){f.mode=26;break}if(32&ne){f.back=-1,f.mode=12;break}if(64&ne){G.msg="invalid literal/length code",f.mode=30;break}f.extra=15&ne,f.mode=22;case 22:if(f.extra){for(M=f.extra;z<M;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}f.length+=X&(1<<f.extra)-1,X>>>=f.extra,z-=f.extra,f.back+=f.extra}f.was=f.length,f.mode=23;case 23:for(;ne=(S=f.distcode[X&(1<<f.distbits)-1])>>>16&255,oe=65535&S,!((ee=S>>>24)<=z);){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(!(240&ne)){for(le=ee,fe=ne,ue=oe;ne=(S=f.distcode[ue+((X&(1<<le+fe)-1)>>le)])>>>16&255,oe=65535&S,!(le+(ee=S>>>24)<=z);){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}X>>>=le,z-=le,f.back+=le}if(X>>>=ee,z-=ee,f.back+=ee,64&ne){G.msg="invalid distance code",f.mode=30;break}f.offset=oe,f.extra=15&ne,f.mode=24;case 24:if(f.extra){for(M=f.extra;z<M;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}f.offset+=X&(1<<f.extra)-1,X>>>=f.extra,z-=f.extra,f.back+=f.extra}if(f.offset>f.dmax){G.msg="invalid distance too far back",f.mode=30;break}f.mode=25;case 25:if(J===0)break e;if(O=U-J,f.offset>O){if((O=f.offset-O)>f.whave&&f.sane){G.msg="invalid distance too far back",f.mode=30;break}ie=O>f.wnext?(O-=f.wnext,f.wsize-O):f.wnext-O,O>f.length&&(O=f.length),ae=f.window}else ae=V,ie=Q-f.offset,O=f.length;for(J<O&&(O=J),J-=O,f.length-=O;V[Q++]=ae[ie++],--O;);f.length===0&&(f.mode=21);break;case 26:if(J===0)break e;V[Q++]=f.length,J--,f.mode=21;break;case 27:if(f.wrap){for(;z<32;){if(Z===0)break e;Z--,X|=T[N++]<<z,z+=8}if(U-=J,G.total_out+=U,f.total+=U,U&&(G.adler=f.check=f.flags?n(f.check,V,U,Q-U):i(f.check,V,U,Q-U)),U=J,(f.flags?X:h(X))!==f.check){G.msg="incorrect data check",f.mode=30;break}z=X=0}f.mode=28;case 28:if(f.wrap&&f.flags){for(;z<32;){if(Z===0)break e;Z--,X+=T[N++]<<z,z+=8}if(X!==(4294967295&f.total)){G.msg="incorrect length check",f.mode=30;break}z=X=0}f.mode=29;case 29:L=1;break e;case 30:L=-3;break e;case 31:return-4;case 32:default:return c}return G.next_out=Q,G.avail_out=J,G.next_in=N,G.avail_in=Z,f.hold=X,f.bits=z,(f.wsize||U!==G.avail_out&&f.mode<30&&(f.mode<27||B!==4))&&W(G,G.output,G.next_out,U-G.avail_out)?(f.mode=31,-4):(H-=G.avail_in,U-=G.avail_out,G.total_in+=H,G.total_out+=U,f.total+=U,f.wrap&&U&&(G.adler=f.check=f.flags?n(f.check,V,U,G.next_out-U):i(f.check,V,U,G.next_out-U)),G.data_type=f.bits+(f.last?64:0)+(f.mode===12?128:0)+(f.mode===20||f.mode===15?256:0),(H==0&&U===0||B===4)&&L===y&&(L=-5),L)},r.inflateEnd=function(G){if(!G||!G.state)return c;var B=G.state;return B.window&&(B.window=null),G.state=null,y},r.inflateGetHeader=function(G,B){var f;return G&&G.state&&2&(f=G.state).wrap?((f.head=B).done=!1,y):c},r.inflateSetDictionary=function(G,B){var f,T=B.length;return G&&G.state?(f=G.state).wrap!==0&&f.mode!==11?c:f.mode===11&&i(1,B,T,0)!==f.check?-3:W(G,B,T,T)?(f.mode=31,-4):(f.havedict=1,y):c},r.inflateInfo="pako inflate (from Nodeca project)"},{"../utils/common":41,"./adler32":43,"./crc32":45,"./inffast":48,"./inftrees":50}],50:[function(e,s,r){"use strict";var t=e("../utils/common"),i=[3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258,0,0],n=[16,16,16,16,16,16,16,16,17,17,17,17,18,18,18,18,19,19,19,19,20,20,20,20,21,21,21,21,16,72,78],l=[1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577,0,0],_=[16,16,16,16,17,17,18,18,19,19,20,20,21,21,22,22,23,23,24,24,25,25,26,26,27,27,28,28,29,29,64,64];s.exports=function(p,w,y,c,v,m,F,h){var E,g,d,o,u,b,x,A,I,W=h.bits,G=0,B=0,f=0,T=0,V=0,N=0,Q=0,Z=0,J=0,X=0,z=null,H=0,U=new t.Buf16(16),O=new t.Buf16(16),ie=null,ae=0;for(G=0;G<=15;G++)U[G]=0;for(B=0;B<c;B++)U[w[y+B]]++;for(V=W,T=15;1<=T&&U[T]===0;T--);if(T<V&&(V=T),T===0)return v[m++]=20971520,v[m++]=20971520,h.bits=1,0;for(f=1;f<T&&U[f]===0;f++);for(V<f&&(V=f),G=Z=1;G<=15;G++)if(Z<<=1,(Z-=U[G])<0)return-1;if(0<Z&&(p===0||T!==1))return-1;for(O[1]=0,G=1;G<15;G++)O[G+1]=O[G]+U[G];for(B=0;B<c;B++)w[y+B]!==0&&(F[O[w[y+B]]++]=B);if(b=p===0?(z=ie=F,19):p===1?(z=i,H-=257,ie=n,ae-=257,256):(z=l,ie=_,-1),G=f,u=m,Q=B=X=0,d=-1,o=(J=1<<(N=V))-1,p===1&&852<J||p===2&&592<J)return 1;for(;;){for(x=G-Q,I=F[B]<b?(A=0,F[B]):F[B]>b?(A=ie[ae+F[B]],z[H+F[B]]):(A=96,0),E=1<<G-Q,f=g=1<<N;v[u+(X>>Q)+(g-=E)]=x<<24|A<<16|I|0,g!==0;);for(E=1<<G-1;X&E;)E>>=1;if(E!==0?(X&=E-1,X+=E):X=0,B++,--U[G]==0){if(G===T)break;G=w[y+F[B]]}if(V<G&&(X&o)!==d){for(Q===0&&(Q=V),u+=f,Z=1<<(N=G-Q);N+Q<T&&!((Z-=U[N+Q])<=0);)N++,Z<<=1;if(J+=1<<N,p===1&&852<J||p===2&&592<J)return 1;v[d=X&o]=V<<24|N<<16|u-m|0}}return X!==0&&(v[u+X]=G-Q<<24|64<<16|0),h.bits=V,0}},{"../utils/common":41}],51:[function(e,s,r){"use strict";s.exports={2:"need dictionary",1:"stream end",0:"","-1":"file error","-2":"stream error","-3":"data error","-4":"insufficient memory","-5":"buffer error","-6":"incompatible version"}},{}],52:[function(e,s,r){"use strict";var t=e("../utils/common"),i=0,n=1;function l(S){for(var k=S.length;0<=--k;)S[k]=0}var _=0,p=29,w=256,y=w+1+p,c=30,v=19,m=2*y+1,F=15,h=16,E=7,g=256,d=16,o=17,u=18,b=[0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],x=[0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],A=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7],I=[16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],W=new Array(2*(y+2));l(W);var G=new Array(2*c);l(G);var B=new Array(512);l(B);var f=new Array(256);l(f);var T=new Array(p);l(T);var V,N,Q,Z=new Array(c);function J(S,k,R,D,P){this.static_tree=S,this.extra_bits=k,this.extra_base=R,this.elems=D,this.max_length=P,this.has_stree=S&&S.length}function X(S,k){this.dyn_tree=S,this.max_code=0,this.stat_desc=k}function z(S){return S<256?B[S]:B[256+(S>>>7)]}function H(S,k){S.pending_buf[S.pending++]=255&k,S.pending_buf[S.pending++]=k>>>8&255}function U(S,k,R){S.bi_valid>h-R?(S.bi_buf|=k<<S.bi_valid&65535,H(S,S.bi_buf),S.bi_buf=k>>h-S.bi_valid,S.bi_valid+=R-h):(S.bi_buf|=k<<S.bi_valid&65535,S.bi_valid+=R)}function O(S,k,R){U(S,R[2*k],R[2*k+1])}function ie(S,k){for(var R=0;R|=1&S,S>>>=1,R<<=1,0<--k;);return R>>>1}function ae(S,k,R){var D,P,j=new Array(F+1),q=0;for(D=1;D<=F;D++)j[D]=q=q+R[D-1]<<1;for(P=0;P<=k;P++){var Y=S[2*P+1];Y!==0&&(S[2*P]=ie(j[Y]++,Y))}}function ee(S){var k;for(k=0;k<y;k++)S.dyn_ltree[2*k]=0;for(k=0;k<c;k++)S.dyn_dtree[2*k]=0;for(k=0;k<v;k++)S.bl_tree[2*k]=0;S.dyn_ltree[2*g]=1,S.opt_len=S.static_len=0,S.last_lit=S.matches=0}function ne(S){8<S.bi_valid?H(S,S.bi_buf):0<S.bi_valid&&(S.pending_buf[S.pending++]=S.bi_buf),S.bi_buf=0,S.bi_valid=0}function oe(S,k,R,D){var P=2*k,j=2*R;return S[P]<S[j]||S[P]===S[j]&&D[k]<=D[R]}function le(S,k,R){for(var D=S.heap[R],P=R<<1;P<=S.heap_len&&(P<S.heap_len&&oe(k,S.heap[P+1],S.heap[P],S.depth)&&P++,!oe(k,D,S.heap[P],S.depth));)S.heap[R]=S.heap[P],R=P,P<<=1;S.heap[R]=D}function fe(S,k,R){var D,P,j,q,Y=0;if(S.last_lit!==0)for(;D=S.pending_buf[S.d_buf+2*Y]<<8|S.pending_buf[S.d_buf+2*Y+1],P=S.pending_buf[S.l_buf+Y],Y++,D===0?O(S,P,k):(O(S,(j=f[P])+w+1,k),(q=b[j])!==0&&U(S,P-=T[j],q),O(S,j=z(--D),R),(q=x[j])!==0&&U(S,D-=Z[j],q)),Y<S.last_lit;);O(S,g,k)}function ue(S,k){var R,D,P,j=k.dyn_tree,q=k.stat_desc.static_tree,Y=k.stat_desc.has_stree,K=k.stat_desc.elems,re=-1;for(S.heap_len=0,S.heap_max=m,R=0;R<K;R++)j[2*R]!==0?(S.heap[++S.heap_len]=re=R,S.depth[R]=0):j[2*R+1]=0;for(;S.heap_len<2;)j[2*(P=S.heap[++S.heap_len]=re<2?++re:0)]=1,S.depth[P]=0,S.opt_len--,Y&&(S.static_len-=q[2*P+1]);for(k.max_code=re,R=S.heap_len>>1;1<=R;R--)le(S,j,R);for(P=K;R=S.heap[1],S.heap[1]=S.heap[S.heap_len--],le(S,j,1),D=S.heap[1],S.heap[--S.heap_max]=R,S.heap[--S.heap_max]=D,j[2*P]=j[2*R]+j[2*D],S.depth[P]=(S.depth[R]>=S.depth[D]?S.depth[R]:S.depth[D])+1,j[2*R+1]=j[2*D+1]=P,S.heap[1]=P++,le(S,j,1),2<=S.heap_len;);S.heap[--S.heap_max]=S.heap[1],function(te,ce){var Ee,pe,Se,_e,Ce,Ue,me=ce.dyn_tree,ct=ce.max_code,xn=ce.stat_desc.static_tree,Fn=ce.stat_desc.has_stree,En=ce.stat_desc.extra_bits,ut=ce.stat_desc.extra_base,Me=ce.stat_desc.max_length,Be=0;for(_e=0;_e<=F;_e++)te.bl_count[_e]=0;for(me[2*te.heap[te.heap_max]+1]=0,Ee=te.heap_max+1;Ee<m;Ee++)Me<(_e=me[2*me[2*(pe=te.heap[Ee])+1]+1]+1)&&(_e=Me,Be++),me[2*pe+1]=_e,ct<pe||(te.bl_count[_e]++,Ce=0,ut<=pe&&(Ce=En[pe-ut]),Ue=me[2*pe],te.opt_len+=Ue*(_e+Ce),Fn&&(te.static_len+=Ue*(xn[2*pe+1]+Ce)));if(Be!==0){do{for(_e=Me-1;te.bl_count[_e]===0;)_e--;te.bl_count[_e]--,te.bl_count[_e+1]+=2,te.bl_count[Me]--,Be-=2}while(0<Be);for(_e=Me;_e!==0;_e--)for(pe=te.bl_count[_e];pe!==0;)ct<(Se=te.heap[--Ee])||(me[2*Se+1]!==_e&&(te.opt_len+=(_e-me[2*Se+1])*me[2*Se],me[2*Se+1]=_e),pe--)}}(S,k),ae(j,re,S.bl_count)}function a(S,k,R){var D,P,j=-1,q=k[1],Y=0,K=7,re=4;for(q===0&&(K=138,re=3),k[2*(R+1)+1]=65535,D=0;D<=R;D++)P=q,q=k[2*(D+1)+1],++Y<K&&P===q||(Y<re?S.bl_tree[2*P]+=Y:P!==0?(P!==j&&S.bl_tree[2*P]++,S.bl_tree[2*d]++):Y<=10?S.bl_tree[2*o]++:S.bl_tree[2*u]++,j=P,re=(Y=0)===q?(K=138,3):P===q?(K=6,3):(K=7,4))}function L(S,k,R){var D,P,j=-1,q=k[1],Y=0,K=7,re=4;for(q===0&&(K=138,re=3),D=0;D<=R;D++)if(P=q,q=k[2*(D+1)+1],!(++Y<K&&P===q)){if(Y<re)for(;O(S,P,S.bl_tree),--Y!=0;);else P!==0?(P!==j&&(O(S,P,S.bl_tree),Y--),O(S,d,S.bl_tree),U(S,Y-3,2)):Y<=10?(O(S,o,S.bl_tree),U(S,Y-3,3)):(O(S,u,S.bl_tree),U(S,Y-11,7));j=P,re=(Y=0)===q?(K=138,3):P===q?(K=6,3):(K=7,4)}}l(Z);var C=!1;function M(S,k,R,D){U(S,(_<<1)+(D?1:0),3),function(P,j,q,Y){ne(P),Y&&(H(P,q),H(P,~q)),t.arraySet(P.pending_buf,P.window,j,q,P.pending),P.pending+=q}(S,k,R,!0)}r._tr_init=function(S){C||(function(){var k,R,D,P,j,q=new Array(F+1);for(P=D=0;P<p-1;P++)for(T[P]=D,k=0;k<1<<b[P];k++)f[D++]=P;for(f[D-1]=P,P=j=0;P<16;P++)for(Z[P]=j,k=0;k<1<<x[P];k++)B[j++]=P;for(j>>=7;P<c;P++)for(Z[P]=j<<7,k=0;k<1<<x[P]-7;k++)B[256+j++]=P;for(R=0;R<=F;R++)q[R]=0;for(k=0;k<=143;)W[2*k+1]=8,k++,q[8]++;for(;k<=255;)W[2*k+1]=9,k++,q[9]++;for(;k<=279;)W[2*k+1]=7,k++,q[7]++;for(;k<=287;)W[2*k+1]=8,k++,q[8]++;for(ae(W,y+1,q),k=0;k<c;k++)G[2*k+1]=5,G[2*k]=ie(k,5);V=new J(W,b,w+1,y,F),N=new J(G,x,0,c,F),Q=new J(new Array(0),A,0,v,E)}(),C=!0),S.l_desc=new X(S.dyn_ltree,V),S.d_desc=new X(S.dyn_dtree,N),S.bl_desc=new X(S.bl_tree,Q),S.bi_buf=0,S.bi_valid=0,ee(S)},r._tr_stored_block=M,r._tr_flush_block=function(S,k,R,D){var P,j,q=0;0<S.level?(S.strm.data_type===2&&(S.strm.data_type=function(Y){var K,re=4093624447;for(K=0;K<=31;K++,re>>>=1)if(1&re&&Y.dyn_ltree[2*K]!==0)return i;if(Y.dyn_ltree[18]!==0||Y.dyn_ltree[20]!==0||Y.dyn_ltree[26]!==0)return n;for(K=32;K<w;K++)if(Y.dyn_ltree[2*K]!==0)return n;return i}(S)),ue(S,S.l_desc),ue(S,S.d_desc),q=function(Y){var K;for(a(Y,Y.dyn_ltree,Y.l_desc.max_code),a(Y,Y.dyn_dtree,Y.d_desc.max_code),ue(Y,Y.bl_desc),K=v-1;3<=K&&Y.bl_tree[2*I[K]+1]===0;K--);return Y.opt_len+=3*(K+1)+5+5+4,K}(S),P=S.opt_len+3+7>>>3,(j=S.static_len+3+7>>>3)<=P&&(P=j)):P=j=R+5,R+4<=P&&k!==-1?M(S,k,R,D):S.strategy===4||j===P?(U(S,2+(D?1:0),3),fe(S,W,G)):(U(S,4+(D?1:0),3),function(Y,K,re,te){var ce;for(U(Y,K-257,5),U(Y,re-1,5),U(Y,te-4,4),ce=0;ce<te;ce++)U(Y,Y.bl_tree[2*I[ce]+1],3);L(Y,Y.dyn_ltree,K-1),L(Y,Y.dyn_dtree,re-1)}(S,S.l_desc.max_code+1,S.d_desc.max_code+1,q+1),fe(S,S.dyn_ltree,S.dyn_dtree)),ee(S),D&&ne(S)},r._tr_tally=function(S,k,R){return S.pending_buf[S.d_buf+2*S.last_lit]=k>>>8&255,S.pending_buf[S.d_buf+2*S.last_lit+1]=255&k,S.pending_buf[S.l_buf+S.last_lit]=255&R,S.last_lit++,k===0?S.dyn_ltree[2*R]++:(S.matches++,k--,S.dyn_ltree[2*(f[R]+w+1)]++,S.dyn_dtree[2*z(k)]++),S.last_lit===S.lit_bufsize-1},r._tr_align=function(S){U(S,2,3),O(S,g,W),function(k){k.bi_valid===16?(H(k,k.bi_buf),k.bi_buf=0,k.bi_valid=0):8<=k.bi_valid&&(k.pending_buf[k.pending++]=255&k.bi_buf,k.bi_buf>>=8,k.bi_valid-=8)}(S)}},{"../utils/common":41}],53:[function(e,s,r){"use strict";s.exports=function(){this.input=null,this.next_in=0,this.avail_in=0,this.total_in=0,this.output=null,this.next_out=0,this.avail_out=0,this.total_out=0,this.msg="",this.state=null,this.data_type=2,this.adler=0}},{}],54:[function(e,s,r){(function(t){(function(i,n){"use strict";if(!i.setImmediate){var l,_,p,w,y=1,c={},v=!1,m=i.document,F=Object.getPrototypeOf&&Object.getPrototypeOf(i);F=F&&F.setTimeout?F:i,l={}.toString.call(i.process)==="[object process]"?function(d){process.nextTick(function(){E(d)})}:function(){if(i.postMessage&&!i.importScripts){var d=!0,o=i.onmessage;return i.onmessage=function(){d=!1},i.postMessage("","*"),i.onmessage=o,d}}()?(w="setImmediate$"+Math.random()+"$",i.addEventListener?i.addEventListener("message",g,!1):i.attachEvent("onmessage",g),function(d){i.postMessage(w+d,"*")}):i.MessageChannel?((p=new MessageChannel).port1.onmessage=function(d){E(d.data)},function(d){p.port2.postMessage(d)}):m&&"onreadystatechange"in m.createElement("script")?(_=m.documentElement,function(d){var o=m.createElement("script");o.onreadystatechange=function(){E(d),o.onreadystatechange=null,_.removeChild(o),o=null},_.appendChild(o)}):function(d){setTimeout(E,0,d)},F.setImmediate=function(d){typeof d!="function"&&(d=new Function(""+d));for(var o=new Array(arguments.length-1),u=0;u<o.length;u++)o[u]=arguments[u+1];var b={callback:d,args:o};return c[y]=b,l(y),y++},F.clearImmediate=h}function h(d){delete c[d]}function E(d){if(v)setTimeout(E,0,d);else{var o=c[d];if(o){v=!0;try{(function(u){var b=u.callback,x=u.args;switch(x.length){case 0:b();break;case 1:b(x[0]);break;case 2:b(x[0],x[1]);break;case 3:b(x[0],x[1],x[2]);break;default:b.apply(n,x)}})(o)}finally{h(d),v=!1}}}}function g(d){d.source===i&&typeof d.data=="string"&&d.data.indexOf(w)===0&&E(+d.data.slice(w.length))}})(typeof self>"u"?t===void 0?this:t:self)}).call(this,typeof global<"u"?global:typeof self<"u"?self:typeof window<"u"?window:{})},{}]},{},[10])(10)})});var Tt=ft((Bt,Lt)=>{(function(e){if(typeof Bt=="object")Lt.exports=e();else if(typeof define=="function"&&define.amd)define(e);else{var s;try{s=window}catch{s=self}s.SparkMD5=e()}})(function(e){"use strict";var s=function(g,d){return g+d&4294967295},r=["0","1","2","3","4","5","6","7","8","9","a","b","c","d","e","f"];function t(g,d,o,u,b,x){return d=s(s(d,g),s(u,x)),s(d<<b|d>>>32-b,o)}function i(g,d){var o=g[0],u=g[1],b=g[2],x=g[3];o+=(u&b|~u&x)+d[0]-680876936|0,o=(o<<7|o>>>25)+u|0,x+=(o&u|~o&b)+d[1]-389564586|0,x=(x<<12|x>>>20)+o|0,b+=(x&o|~x&u)+d[2]+606105819|0,b=(b<<17|b>>>15)+x|0,u+=(b&x|~b&o)+d[3]-1044525330|0,u=(u<<22|u>>>10)+b|0,o+=(u&b|~u&x)+d[4]-176418897|0,o=(o<<7|o>>>25)+u|0,x+=(o&u|~o&b)+d[5]+1200080426|0,x=(x<<12|x>>>20)+o|0,b+=(x&o|~x&u)+d[6]-1473231341|0,b=(b<<17|b>>>15)+x|0,u+=(b&x|~b&o)+d[7]-45705983|0,u=(u<<22|u>>>10)+b|0,o+=(u&b|~u&x)+d[8]+1770035416|0,o=(o<<7|o>>>25)+u|0,x+=(o&u|~o&b)+d[9]-1958414417|0,x=(x<<12|x>>>20)+o|0,b+=(x&o|~x&u)+d[10]-42063|0,b=(b<<17|b>>>15)+x|0,u+=(b&x|~b&o)+d[11]-1990404162|0,u=(u<<22|u>>>10)+b|0,o+=(u&b|~u&x)+d[12]+1804603682|0,o=(o<<7|o>>>25)+u|0,x+=(o&u|~o&b)+d[13]-40341101|0,x=(x<<12|x>>>20)+o|0,b+=(x&o|~x&u)+d[14]-1502002290|0,b=(b<<17|b>>>15)+x|0,u+=(b&x|~b&o)+d[15]+1236535329|0,u=(u<<22|u>>>10)+b|0,o+=(u&x|b&~x)+d[1]-165796510|0,o=(o<<5|o>>>27)+u|0,x+=(o&b|u&~b)+d[6]-1069501632|0,x=(x<<9|x>>>23)+o|0,b+=(x&u|o&~u)+d[11]+643717713|0,b=(b<<14|b>>>18)+x|0,u+=(b&o|x&~o)+d[0]-373897302|0,u=(u<<20|u>>>12)+b|0,o+=(u&x|b&~x)+d[5]-701558691|0,o=(o<<5|o>>>27)+u|0,x+=(o&b|u&~b)+d[10]+38016083|0,x=(x<<9|x>>>23)+o|0,b+=(x&u|o&~u)+d[15]-660478335|0,b=(b<<14|b>>>18)+x|0,u+=(b&o|x&~o)+d[4]-405537848|0,u=(u<<20|u>>>12)+b|0,o+=(u&x|b&~x)+d[9]+568446438|0,o=(o<<5|o>>>27)+u|0,x+=(o&b|u&~b)+d[14]-1019803690|0,x=(x<<9|x>>>23)+o|0,b+=(x&u|o&~u)+d[3]-187363961|0,b=(b<<14|b>>>18)+x|0,u+=(b&o|x&~o)+d[8]+1163531501|0,u=(u<<20|u>>>12)+b|0,o+=(u&x|b&~x)+d[13]-1444681467|0,o=(o<<5|o>>>27)+u|0,x+=(o&b|u&~b)+d[2]-51403784|0,x=(x<<9|x>>>23)+o|0,b+=(x&u|o&~u)+d[7]+1735328473|0,b=(b<<14|b>>>18)+x|0,u+=(b&o|x&~o)+d[12]-1926607734|0,u=(u<<20|u>>>12)+b|0,o+=(u^b^x)+d[5]-378558|0,o=(o<<4|o>>>28)+u|0,x+=(o^u^b)+d[8]-2022574463|0,x=(x<<11|x>>>21)+o|0,b+=(x^o^u)+d[11]+1839030562|0,b=(b<<16|b>>>16)+x|0,u+=(b^x^o)+d[14]-35309556|0,u=(u<<23|u>>>9)+b|0,o+=(u^b^x)+d[1]-1530992060|0,o=(o<<4|o>>>28)+u|0,x+=(o^u^b)+d[4]+1272893353|0,x=(x<<11|x>>>21)+o|0,b+=(x^o^u)+d[7]-155497632|0,b=(b<<16|b>>>16)+x|0,u+=(b^x^o)+d[10]-1094730640|0,u=(u<<23|u>>>9)+b|0,o+=(u^b^x)+d[13]+681279174|0,o=(o<<4|o>>>28)+u|0,x+=(o^u^b)+d[0]-358537222|0,x=(x<<11|x>>>21)+o|0,b+=(x^o^u)+d[3]-722521979|0,b=(b<<16|b>>>16)+x|0,u+=(b^x^o)+d[6]+76029189|0,u=(u<<23|u>>>9)+b|0,o+=(u^b^x)+d[9]-640364487|0,o=(o<<4|o>>>28)+u|0,x+=(o^u^b)+d[12]-421815835|0,x=(x<<11|x>>>21)+o|0,b+=(x^o^u)+d[15]+530742520|0,b=(b<<16|b>>>16)+x|0,u+=(b^x^o)+d[2]-995338651|0,u=(u<<23|u>>>9)+b|0,o+=(b^(u|~x))+d[0]-198630844|0,o=(o<<6|o>>>26)+u|0,x+=(u^(o|~b))+d[7]+1126891415|0,x=(x<<10|x>>>22)+o|0,b+=(o^(x|~u))+d[14]-1416354905|0,b=(b<<15|b>>>17)+x|0,u+=(x^(b|~o))+d[5]-57434055|0,u=(u<<21|u>>>11)+b|0,o+=(b^(u|~x))+d[12]+1700485571|0,o=(o<<6|o>>>26)+u|0,x+=(u^(o|~b))+d[3]-1894986606|0,x=(x<<10|x>>>22)+o|0,b+=(o^(x|~u))+d[10]-1051523|0,b=(b<<15|b>>>17)+x|0,u+=(x^(b|~o))+d[1]-2054922799|0,u=(u<<21|u>>>11)+b|0,o+=(b^(u|~x))+d[8]+1873313359|0,o=(o<<6|o>>>26)+u|0,x+=(u^(o|~b))+d[15]-30611744|0,x=(x<<10|x>>>22)+o|0,b+=(o^(x|~u))+d[6]-1560198380|0,b=(b<<15|b>>>17)+x|0,u+=(x^(b|~o))+d[13]+1309151649|0,u=(u<<21|u>>>11)+b|0,o+=(b^(u|~x))+d[4]-145523070|0,o=(o<<6|o>>>26)+u|0,x+=(u^(o|~b))+d[11]-1120210379|0,x=(x<<10|x>>>22)+o|0,b+=(o^(x|~u))+d[2]+718787259|0,b=(b<<15|b>>>17)+x|0,u+=(x^(b|~o))+d[9]-343485551|0,u=(u<<21|u>>>11)+b|0,g[0]=o+g[0]|0,g[1]=u+g[1]|0,g[2]=b+g[2]|0,g[3]=x+g[3]|0}function n(g){var d=[],o;for(o=0;o<64;o+=4)d[o>>2]=g.charCodeAt(o)+(g.charCodeAt(o+1)<<8)+(g.charCodeAt(o+2)<<16)+(g.charCodeAt(o+3)<<24);return d}function l(g){var d=[],o;for(o=0;o<64;o+=4)d[o>>2]=g[o]+(g[o+1]<<8)+(g[o+2]<<16)+(g[o+3]<<24);return d}function _(g){var d=g.length,o=[1732584193,-271733879,-1732584194,271733878],u,b,x,A,I,W;for(u=64;u<=d;u+=64)i(o,n(g.substring(u-64,u)));for(g=g.substring(u-64),b=g.length,x=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],u=0;u<b;u+=1)x[u>>2]|=g.charCodeAt(u)<<(u%4<<3);if(x[u>>2]|=128<<(u%4<<3),u>55)for(i(o,x),u=0;u<16;u+=1)x[u]=0;return A=d*8,A=A.toString(16).match(/(.*?)(.{0,8})$/),I=parseInt(A[2],16),W=parseInt(A[1],16)||0,x[14]=I,x[15]=W,i(o,x),o}function p(g){var d=g.length,o=[1732584193,-271733879,-1732584194,271733878],u,b,x,A,I,W;for(u=64;u<=d;u+=64)i(o,l(g.subarray(u-64,u)));for(g=u-64<d?g.subarray(u-64):new Uint8Array(0),b=g.length,x=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],u=0;u<b;u+=1)x[u>>2]|=g[u]<<(u%4<<3);if(x[u>>2]|=128<<(u%4<<3),u>55)for(i(o,x),u=0;u<16;u+=1)x[u]=0;return A=d*8,A=A.toString(16).match(/(.*?)(.{0,8})$/),I=parseInt(A[2],16),W=parseInt(A[1],16)||0,x[14]=I,x[15]=W,i(o,x),o}function w(g){var d="",o;for(o=0;o<4;o+=1)d+=r[g>>o*8+4&15]+r[g>>o*8&15];return d}function y(g){var d;for(d=0;d<g.length;d+=1)g[d]=w(g[d]);return g.join("")}y(_("hello"))!=="5d41402abc4b2a76b9719d911017c592"&&(s=function(g,d){var o=(g&65535)+(d&65535),u=(g>>16)+(d>>16)+(o>>16);return u<<16|o&65535}),typeof ArrayBuffer<"u"&&!ArrayBuffer.prototype.slice&&function(){function g(d,o){return d=d|0||0,d<0?Math.max(d+o,0):Math.min(d,o)}ArrayBuffer.prototype.slice=function(d,o){var u=this.byteLength,b=g(d,u),x=u,A,I,W,G;return o!==e&&(x=g(o,u)),b>x?new ArrayBuffer(0):(A=x-b,I=new ArrayBuffer(A),W=new Uint8Array(I),G=new Uint8Array(this,b,A),W.set(G),I)}}();function c(g){return/[\u0080-\uFFFF]/.test(g)&&(g=unescape(encodeURIComponent(g))),g}function v(g,d){var o=g.length,u=new ArrayBuffer(o),b=new Uint8Array(u),x;for(x=0;x<o;x+=1)b[x]=g.charCodeAt(x);return d?b:u}function m(g){return String.fromCharCode.apply(null,new Uint8Array(g))}function F(g,d,o){var u=new Uint8Array(g.byteLength+d.byteLength);return u.set(new Uint8Array(g)),u.set(new Uint8Array(d),g.byteLength),o?u:u.buffer}function h(g){var d=[],o=g.length,u;for(u=0;u<o-1;u+=2)d.push(parseInt(g.substr(u,2),16));return String.fromCharCode.apply(String,d)}function E(){this.reset()}return E.prototype.append=function(g){return this.appendBinary(c(g)),this},E.prototype.appendBinary=function(g){this._buff+=g,this._length+=g.length;var d=this._buff.length,o;for(o=64;o<=d;o+=64)i(this._hash,n(this._buff.substring(o-64,o)));return this._buff=this._buff.substring(o-64),this},E.prototype.end=function(g){var d=this._buff,o=d.length,u,b=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],x;for(u=0;u<o;u+=1)b[u>>2]|=d.charCodeAt(u)<<(u%4<<3);return this._finish(b,o),x=y(this._hash),g&&(x=h(x)),this.reset(),x},E.prototype.reset=function(){return this._buff="",this._length=0,this._hash=[1732584193,-271733879,-1732584194,271733878],this},E.prototype.getState=function(){return{buff:this._buff,length:this._length,hash:this._hash.slice()}},E.prototype.setState=function(g){return this._buff=g.buff,this._length=g.length,this._hash=g.hash,this},E.prototype.destroy=function(){delete this._hash,delete this._buff,delete this._length},E.prototype._finish=function(g,d){var o=d,u,b,x;if(g[o>>2]|=128<<(o%4<<3),o>55)for(i(this._hash,g),o=0;o<16;o+=1)g[o]=0;u=this._length*8,u=u.toString(16).match(/(.*?)(.{0,8})$/),b=parseInt(u[2],16),x=parseInt(u[1],16)||0,g[14]=b,g[15]=x,i(this._hash,g)},E.hash=function(g,d){return E.hashBinary(c(g),d)},E.hashBinary=function(g,d){var o=_(g),u=y(o);return d?h(u):u},E.ArrayBuffer=function(){this.reset()},E.ArrayBuffer.prototype.append=function(g){var d=F(this._buff.buffer,g,!0),o=d.length,u;for(this._length+=g.byteLength,u=64;u<=o;u+=64)i(this._hash,l(d.subarray(u-64,u)));return this._buff=u-64<o?new Uint8Array(d.buffer.slice(u-64)):new Uint8Array(0),this},E.ArrayBuffer.prototype.end=function(g){var d=this._buff,o=d.length,u=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],b,x;for(b=0;b<o;b+=1)u[b>>2]|=d[b]<<(b%4<<3);return this._finish(u,o),x=y(this._hash),g&&(x=h(x)),this.reset(),x},E.ArrayBuffer.prototype.reset=function(){return this._buff=new Uint8Array(0),this._length=0,this._hash=[1732584193,-271733879,-1732584194,271733878],this},E.ArrayBuffer.prototype.getState=function(){var g=E.prototype.getState.call(this);return g.buff=m(g.buff),g},E.ArrayBuffer.prototype.setState=function(g){return g.buff=v(g.buff,!0),E.prototype.setState.call(this,g)},E.ArrayBuffer.prototype.destroy=E.prototype.destroy,E.ArrayBuffer.prototype._finish=E.prototype._finish,E.ArrayBuffer.hash=function(g,d){var o=p(new Uint8Array(g)),u=y(o);return d?h(u):u},E})});var $={USE_PURGE_START:!1,USE_BEDLEVEL_COOLING:!1,CURRENT_MODE:null,my_files:[],fileInput:null,li_prototype:null,playlist_ol:null,err:null,p_scale:null,instant_processing:!1,last_file:!1,ams_max_file_id:-1,enable_md5:!0,open_in_bbs:!1,GLOBAL_AMS:{devices:[],overridesPerPlate:new Map,seenKeys:new Set}};function $e(e){document.getElementById("settings_wrapper").style.display=e?"table-cell":"none"}function pt(e){e.value==""&&(e.value=e.placeholder,e.select())}function mt(e,s,r){e.value==""?trg_val=e.placeholder:trg_val=e.value,e.style.width=Math.min(r,Math.max(s,trg_val.length+2))+"ch"}function ht(){let e=document.getElementById("raisebed_offset_mm"),s=e?parseFloat(e.value):30;return Number.isFinite(s)?Math.max(0,Math.min(200,s)):30}function gt(){let e=document.getElementById("cooldown_target_bed_temp"),s=e?parseFloat(e.value):23;return Number.isFinite(s)?Math.max(0,Math.min(120,s)):23}function Le(){let e=document.getElementById("opt_secure_pushoff");return!!(e&&e.checked)}function wt(){let e=document.getElementById("extra_pushoff_levels"),s=e?parseInt(e.value,10):1;return Number.isFinite(s)?Math.max(1,Math.min(10,s)):1}function yt(){let e=document.getElementById("cooldown_max_time"),s=e?parseInt(e.value,10):40;return Number.isFinite(s)?Math.max(5,Math.min(120,s)):40}function de(){Cn(),An()}function An(){let e=document.getElementById("total_time"),s=document.getElementById("used_plates"),r=document.getElementById("loops"),t=$.playlist_ol;if(!e||!s||!r||!t)return;let i=parseFloat(r.value)||1,n=0,l=0,_=t.getElementsByTagName("li");for(let p=0;p<_.length;p++){let w=_[p].getElementsByClassName("p_rep")[0],y=_[p].getElementsByClassName("p_time")[0],c=parseFloat(w?.value)||0,v=parseInt(y?.title,10)||0;c>0?(l+=c*v,_[p].classList.remove("inactive"),n+=c):_[p].classList.add("inactive")}n*=i,l*=i,e.innerText=Xn(l),s.innerText=n}function Xn(e){let s=Math.floor(e/86400),r=Math.floor((e-s*86400)/3600),t=Math.floor((e-s*86400-r*3600)/60),i=Math.floor(e-s*86400-r*3600-t*60);return(s?s+"d ":"")+(r?r+"h ":"")+t+"m "+i+"s "}function Cn(){let e=document.getElementById("filament_total"),s=$.playlist_ol;if(!e||!s)return;let r=s.getElementsByClassName("p_filament"),t=[],i=[],n=[],l=[],_=-1;for(let v=0;v<r.length;v++){let m=r[v],F=parseInt(m.getElementsByClassName("f_slot")[0]?.innerText,10);if(!Number.isFinite(F))continue;let h=F-1;t[h]||(t[h]=0),i[h]||(i[h]=0),n[h]||(n[h]=[]);let E=m.parentElement?.parentElement?.getElementsByClassName("p_rep")[0],g=parseFloat(E?.value)||0,d=parseFloat(m.getElementsByClassName("f_used_m")[0]?.innerText)||0,o=parseFloat(m.getElementsByClassName("f_used_g")[0]?.innerText)||0;t[h]+=g*d,i[h]+=g*o;let u=m.getElementsByClassName("f_type")[0],b=u?.dataset?.origType||"",x=u?.innerText||"",A=b||x||"";A&&n[h].push(A);let I=m.getElementsByClassName("f_color")[0]?.dataset?.f_color||"";if(I&&(l[h]=I),h>_&&g>0){_=h;let W=m.parentElement?.parentElement?.getElementsByClassName("f_id")[0];$.ams_max_file_id=W?.title??$.ams_max_file_id}}let p=document.getElementById("loops"),w=parseFloat(p?.value)||1,y=t.map(v=>(v||0)*w),c=i.map(v=>(v||0)*w);e.innerHTML="";for(let v=0;v<Math.max(y.length,c.length);v++){let m=y[v]||0,F=c[v]||0;if(m===0&&F===0)continue;let h=document.createElement("div"),E=Math.round(m*100)/100,g=Math.round(F*100)/100;h.innerHTML=`Slot ${v+1}: <br>${E}m <br> ${g}g`,h.dataset.used_m=String(E),h.dataset.used_g=String(g);let d=(n[v]||[]).find(o=>!!o)||"";h.dataset.f_type=d,h.title=String(v+1),e.appendChild(h)}}function vt(e){return[...e.querySelectorAll(".plate-x1p1-settings .obj-coords .obj-coord-row input.obj-x")].map(r=>parseFloat(r.value)).filter(r=>Number.isFinite(r)).sort((r,t)=>t-r)}function Te(){if(!($.CURRENT_MODE==="X1"||$.CURRENT_MODE==="P1"))return!0;let e=document.querySelectorAll(".plate-x1p1-settings .obj-coords input.obj-x"),s=!1;return e.forEach(r=>{let t=parseFloat(r.value);(!Number.isFinite(t)||t===0)&&(s=!0,r.classList.add("coord-error"),setTimeout(()=>r.classList.remove("coord-error"),5e3))}),s?(alert("Warning: Some X coordinates are missing (0). Please enter valid values before exporting."),!1):!0}function xt(e){let s=e.closest("li.list_item");if(!s)return;s.remove(),typeof de=="function"&&de(),document.querySelectorAll("#playlist_ol li.list_item:not(.hidden)").length===0&&location.reload()}function Ft(e){e.classList.add("slist");let s=e.getElementsByTagName("li"),r=null;for(let t of s)t.draggable=!0,t.ondragstart=i=>{r=t,r.classList.add("targeted");for(let n of s)n!=r&&n.classList.add("hint")},t.ondragenter=i=>{t!=r&&t.classList.add("active")},t.ondragleave=()=>{t.classList.remove("active")},t.ondragend=()=>{for(let i of s)i.classList.remove("hint"),i.classList.remove("active"),i.classList.remove("targeted")},t.ondragover=i=>{i.preventDefault()},t.ondrop=i=>{if(i.preventDefault(),t!=r){let n=0,l=0;for(let _=0;_<s.length;_++)r==s[_]&&(n=_),t==s[_]&&(l=_);n<l?t.parentNode.insertBefore(r,t.nextSibling):t.parentNode.insertBefore(r,t)}};console.log("list was made sortable")}function Et(e,s){if(!s&&(s=document.querySelector("#x1p1-settings .obj-coords"),!s))return;s.innerHTML="";let r=Math.max(1,Math.min(5,e|0));for(let t=1;t<=r;t++){let i=document.createElement("div");i.className="obj-coord",i.innerHTML=`
      <span class="coord-title">Object ${t}</span>
      <div class="coord-row">
        <label>X <input type="number" id="obj${t}-x" step="1" value="0"></label>
      </div>
    `,s.appendChild(i)}}function bt(e,s){let r=e.querySelector(".obj-coords");if(!r)return;r.innerHTML="";let t=Math.max(1,Math.min(5,s|0));for(let i=1;i<=t;i++){let n=document.createElement("div");n.className="obj-coord-row",n.innerHTML=`
      <b>Object ${i}</b>
      <label>X <input type="number" class="obj-x" step="1" value="0" data-obj="${i}"></label>
    `,r.appendChild(n)}}function qe(e){let s=e.querySelector(".plate-x1p1-settings");if(s){let t=$.CURRENT_MODE==="X1"||$.CURRENT_MODE==="P1";s.classList.toggle("hidden",!t)}let r=e.querySelector(".obj-count");r&&(bt(e,parseInt(r.value||"1",10)),r.addEventListener("change",t=>{bt(e,parseInt(t.target.value||"1",10))}))}function We(e){let s=e.querySelector(".p_icon");if(!s)return;let r=s.parentElement;if((!r||!r.classList.contains("p_imgwrap"))&&(r=document.createElement("div"),r.className="p_imgwrap",s.parentNode.insertBefore(r,s),r.appendChild(s)),!r.querySelector(".plate-duplicate")){let t=document.createElement("button");t.className="plate-duplicate",t.type="button",t.title="Duplicate this plate",t.textContent="+",r.appendChild(t)}}function St(e){let s=e.cloneNode(!0);s.classList.remove("hidden"),We(s),qe(s),e.parentNode.insertBefore(s,e.nextSibling),de()}function se(e){let s=$.p_scale||document.getElementById("progress_scale");if(!s)return;$.p_scale=s;let r=s,t=r.parentElement;if(!t)return;if(e<0){r.style.width="0%",t.style.opacity="0";return}let i=Math.max(0,Math.min(100,e|0));t.style.opacity="1",r.style.width=i+"%"}var pn=ye(be(),1);var Bn=ye(be(),1),Ln=/^[ \t]*;[ \t]*EXECUTABLE_BLOCK_START[^\n]*\n?/m,Tn=/^[ \t]*;[ \t]*MACHINE_START_GCODE_END[^\n]*\n?/m,In=/^[ \t]*;[ \t]*MACHINE_END_GCODE_START[^\n]*\n?/m;function Gt(e,s){if(s<0)return-1;let r=e.indexOf(`
`,s);return r===-1?e.length:r+1}function ke(e){let s=Ln.exec(e),r=s?s.index:-1,t=s?Gt(e,r):-1,i=Tn.exec(e),n=i?i.index:-1,l=i?Gt(e,n):-1,_=In.exec(e),p=_?_.index:-1;return r>=0&&l>=0&&p>=0?{header:e.slice(0,r),startseq:e.slice(r,l),body:e.slice(l,p),endseq:e.slice(p)}:r>=0&&l<0&&p<0?{header:e.slice(0,r),startseq:e.slice(r),body:"",endseq:""}:r>=0&&l>=0&&p<0?{header:e.slice(0,r),startseq:e.slice(r,l),body:e.slice(l),endseq:""}:r<0&&l<0&&p>=0?{header:"",startseq:"",body:e.slice(0,p),endseq:e.slice(p)}:{header:"",startseq:"",body:e,endseq:""}}function kt(e){let s=e.match(/^[ \t]*;[ \t]*printer_model\s*=\s*(.+)$/mi);if(!s)return null;let r=s[1].trim();return/^Bambu Lab X1(?: Carbon|E)?$/i.test(r)?"X1":/^Bambu Lab A1 mini$/i.test(r)?"A1M":/^Bambu Lab P1(?:S|P)$/i.test(r)?"P1":"UNSUPPORTED"}function Je(e){let s=e.match(/^[ \t]*;[ \t]*max_z_height:\s*([0-9]+(?:\.[0-9]+)?)/m);return s?parseFloat(s[1]):null}function Ke(e){return(e.header||"")+(e.startseq||"")+(e.body||"")+(e.endseq||"")}function Rn(e){$.CURRENT_MODE=e,document.body.setAttribute("data-mode",e);let s=e==="X1"||e==="P1",r=document.getElementById("mode_options"),t=document.getElementById("x1p1-settings");if(r&&r.classList.toggle("hidden",!s),t&&t.classList.toggle("hidden",!s),s){let i=document.getElementById("object-count");Et(parseInt(i&&i.value?i.value:"1",10))}document.querySelectorAll(".plate-x1p1-settings").forEach(i=>{i.classList.toggle("hidden",!s)}),console.log("Mode switched to:",e)}function Pt(e,s){if(e==="UNSUPPORTED"||!e)return alert(`This printer model is not supported yet in this app (file: ${s}).`),!1;if($.CURRENT_MODE==null){Rn(e);let r={A1M:"mode_a1m",X1:"mode_x1",P1:"mode_p1"},t=document.getElementById(r[e]);return t&&(t.checked=!0),!0}return $.CURRENT_MODE!==e?(alert(`Printer mismatch.
Loaded queue is ${$.CURRENT_MODE}, new file is ${e}.
The new plate will not be added.`),!1):!0}var zt=["#cccccc","#cccccc","#cccccc","#cccccc"];function Dn(e){let s=e.querySelector(".f_color"),r=e.querySelector(".f_slot"),t=parseInt(r?.textContent?.trim()||"1",10)||1,i=Math.max(0,Math.min(3,t-1));s.style.background=ve(i),s.dataset.slotIndex=String(i)}function Re(e){e.querySelectorAll(".p_filaments .p_filament").forEach(Dn)}function De(){let e=$.GLOBAL_AMS;return e.devices||(e.devices=[]),e.devices[0]?e.devices[0].slots.forEach(s=>{s.manual==null&&(s.manual=!1)}):e.devices[0]={id:0,slots:[0,1,2,3].map(s=>({key:`P0S${s}`,color:null,conflict:!1,manual:!1}))},e.devices[0]}function et(e){if(!e)return"";if(/^#([0-9a-f]{3}|[0-9a-f]{6})$/i.test(e))return e;let s=/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/i.exec(e);if(s){let[n,l,_]=s.slice(1).map(p=>(+p).toString(16).padStart(2,"0"));return`#${n}${l}${_}`}let r=document.createElement("canvas").getContext("2d");r.fillStyle="#000",r.fillStyle=e;let t=r.fillStyle;if(/^#/.test(t))return t;let i=/rgba?\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)/i.exec(t);if(i){let[n,l,_]=i.slice(1).map(p=>(+p).toString(16).padStart(2,"0"));return`#${n}${l}${_}`}return""}function Nn(e){let s=e?.dataset?.f_color||e?.style?.backgroundColor||"";return!s&&e&&(s=getComputedStyle(e).backgroundColor),et(s)}function ve(e){let s=De().slots[e];return s&&s.color||zt[e]||"#cccccc"}function ge(){let e=De(),s=[null,null,null,null],r=document.getElementById("playlist_ol");r&&r.querySelectorAll("li.list_item .p_filament").forEach(t=>{let i=t.querySelector(".f_slot"),n=t.querySelector(".f_color");if(!i||!n)return;let _=parseInt(i.textContent?.trim()||"0",10)-1;if(_<0||_>3)return;let p=Nn(n);p&&(s[_]||(s[_]=p))});for(let t=0;t<4;t++){let i=e.slots[t];i.manual||(i.color=s[t]||zt[t],i.conflict=!1)}xe()}function Ne(e){e.querySelectorAll(".p_filament").forEach(s=>{let r=s.querySelector(".f_color"),t=s.querySelector(".f_slot");if(!r||!t)return;let i=parseInt(t.textContent?.trim()||"1",10)||1;r.dataset.slotIndex=String(Math.max(0,Math.min(3,i-1)))})}function On(e,s){let r=e.closest(".p_filament");if(!r)return;let t=r.querySelector(".f_slot");t&&(t.textContent=String(s+1)),e.dataset.slotIndex=String(s);let i=ve(s);e.style.background=i,de()}var we=null,Ve=null,Qe=!1;function Ie(){we&&(we.remove(),we=null,Ve=null),Qe=!0,setTimeout(()=>{Qe=!1},0)}function At(e){if(Qe)return;if(we&&Ve===e){Ie();return}Ie(),Ve=e;let s=+(e.dataset.slotIndex||0),r=document.createElement("div");r.className="slot-dropdown",r.setAttribute("data-role","slot-dropdown");for(let i=0;i<4;i++){let n=document.createElement("div");n.className="slot-dropdown-item",n.dataset.slotIndex=String(i);let l=document.createElement("span");l.className="dot",l.style.background=ve(i);let _=document.createElement("span");_.textContent=`Slot ${i+1}`,i===s&&n.classList.add("current"),n.append(l,_),n.addEventListener("click",()=>{On(e,i),Ie()}),r.appendChild(n)}document.body.appendChild(r);let t=e.getBoundingClientRect();r.style.left=`${window.scrollX+t.left}px`,r.style.top=`${window.scrollY+t.bottom+6}px`,setTimeout(()=>{document.addEventListener("mousedown",i=>{we&&(we.contains(i.target)||Ie())},{once:!0})},0),we=r}function Zn(){let e=document.getElementById("playlist_ol");e&&e.querySelectorAll("li.list_item .p_filaments .p_filament").forEach(s=>{let r=s.querySelector(".f_slot"),t=s.querySelector(".f_color");if(!r||!t)return;let i=parseInt(r.textContent?.trim()||"1",10)||1,n=Math.max(0,Math.min(3,i-1)),l=ve(n);t.style.background=l})}function jn(e){for(let s=1;s<=4;s++){let r=e.querySelector(`:scope > div[title="${s}"]`)||e.querySelector(`:scope > div[data-slot="${s}"]`);r||(r=document.createElement("div"),r.setAttribute("title",String(s)),r.innerHTML=`Slot ${s}: <br> 0.00m <br> 0.00g`,e.appendChild(r))}}function xe(){let e=document.getElementById("filament_total");e&&(jn(e),e.querySelectorAll(":scope > div[title]").forEach(s=>{let r=+(s.getAttribute("title")||"0");if(!r)return;let t=s.querySelector(":scope > .f_color");t||(t=document.createElement("div"),t.className="f_color",s.insertBefore(t,s.firstChild),s.insertBefore(document.createElement("br"),t.nextSibling));let i=r-1,n=ve(i);t.dataset.slotIndex=String(i),t.dataset.f_color=n,t.style.background=n}))}function Xt(){let e=document.getElementById("filament_total");if(!e)return;let s=!1;new MutationObserver(()=>{s||(s=!0,requestAnimationFrame(()=>{s=!1,ge(),xe(),Zn()}))}).observe(e,{childList:!0,subtree:!0})}function Yn(e,s){let t=De().slots[e];t&&(t.meta=t.meta||{},s.color!=null&&(t.color=et(s.color)),s.type!=null&&(t.meta.type=s.type),s.vendor!=null&&(t.meta.vendor=s.vendor),t.manual=!0,xe())}function Ct(e){let s=ve(e),t=De().slots[e]||{},i=t.meta?.type||"PLA",n=t.meta?.vendor||"Generic",l=document.createElement("div");l.className="slot-modal-backdrop";let _=document.createElement("div");_.className="slot-modal",_.innerHTML=`
    <h4>Slot ${e+1}</h4>
    <div class="row">
      <label>Farbe:</label>
      <input type="color" id="slotColor" value="${s}">
    </div>
    <div class="row">
      <label>Material:</label>
      <select id="slotType">
        ${["PLA","PETG","ABS","ASA","TPU","PC","PA","PVA","Other"].map(w=>`<option value="${w}" ${w===i?"selected":""}>${w}</option>`).join("")}
      </select>
    </div>
    <div class="row">
      <label>Producer:</label>
      <select id="slotVendor">
        ${["Polymaker","Bambu Lab","eSun","Generic","Other"].map(w=>`<option value="${w}" ${w===n?"selected":""}>${w}</option>`).join("")}
      </select>
    </div>
    <div class="actions">
      <button id="slotCancel">Cancel</button>
      <button id="slotSave">Save</button>
    </div>
  `,l.appendChild(_),document.body.appendChild(l);let p=w=>_.querySelector(w);p("#slotCancel").onclick=()=>l.remove(),p("#slotSave").onclick=()=>{let w=p("#slotColor").value,y=p("#slotType").value,c=p("#slotVendor").value;Yn(e,{color:w,type:y,vendor:c});let v=document.querySelector(`#filament_total > div[title="${e+1}"]`);v&&(v.dataset.f_color=et(w),v.dataset.f_type=y,v.dataset.f_vendor=c),l.remove()}}var at=ye(be(),1);var rn=ye(be(),1),an=ye(Tt(),1);function he(e){return e.replace(/[.*+?^${}()|[\]\\]/g,"\\$&")}function Pe(e,s,r="gm"){try{return[...e.matchAll(new RegExp(s,r))].length}catch{return 0}}function tt(e,s,r=!1){return(r?new RegExp(s,"gm"):new RegExp(`(^|\\n)[ \\t]*${he(s)}[^\\n]*(\\n|$)`,"gm")).test(e)}function It(e,s,r,t,i,n={}){let l=i!==t,_=i.length-t.length,p={id:e.id,action:e.action,scope:r,plate:s.plateIndex,totalPlates:s.totalPlates,mode:s.mode,isLastPlate:!!s.isLastPlate,applied:l,deltaBytes:_,...n};(l?console.info:console.warn)("[SWAP_RULE]",p)}function Fe(e,s,r,t=!1){let i=c=>c.replace(/[.*+?^${}()|[\]\\]/g,"\\$&"),n=t?new RegExp(s,"m"):new RegExp(`(^|\\n)[ \\t]*${i(s)}[^\\n]*\\n`,"m"),l=e.match(n);if(!l)return{found:!1};let _=(l.index??0)+l[0].length,p=t?new RegExp(r,"m"):new RegExp(`(^|\\n)[ \\t]*${i(r)}[^\\n]*\\n`,"m"),y=e.slice(_).match(p);return y?{found:!0,sIdx:_,eIdx:_+(y.index??0)}:{found:!1}}function Rt(e,s){let r=e.when||{};if(r.modes&&r.modes.length&&!r.modes.includes(s.mode))return"mode_mismatch";for(let i of r.requireTrue||[]){let n=document.getElementById(i);if(!n||!n.checked)return`requireTrue_missing:${i}`}for(let i of r.requireFalse||[]){let n=document.getElementById(i);if(n&&n.checked)return`requireFalse_blocked:${i}`}let t=e.onlyIf||{};return Number.isFinite(t.plateIndexGreaterThan)&&!(s.plateIndex>t.plateIndexGreaterThan)?"plateIndexGreaterThan_false":Number.isFinite(t.plateIndexEquals)&&s.plateIndex!==t.plateIndexEquals?"plateIndexEquals_false":typeof t.isLastPlate=="boolean"&&!!s.isLastPlate!==t.isLastPlate?"isLastPlate_mismatch":"active"}function nt(e){let s=window&&window[e]||globalThis&&globalThis[e];return typeof s=="string"?s:""}function Dt(e=""){let s=String(e),r=/(?:^|\s)P(\d{1,3})\b/i.exec(s),t=r?+r[1]:0,i=/(?:^|\s)S(\d{1,3})(?=\D|$)/i.exec(s),n=i?+i[1]:255,l=/S\d+A\b/i.test(s),_=/(?:^|\s)A\b/i.test(s);return{p:t,s:n,A:l||_}}function rt(e,s,r,{useRegex:t=!1}={}){let i=v=>v.replace(/[.*+?^${}()|[\]\\]/g,"\\$&"),n=t?new RegExp(s,"m"):new RegExp(`(^|\\n)[ \\t]*${i(s)}[^
]*\\n`,"m"),l=e.match(n);if(!l)return e;let _=(l.index??0)+l[0].length,p=t?new RegExp(r,"m"):new RegExp(`(^|\\n)[ \\t]*${i(r)}[^
]*\\n`,"m"),y=e.slice(_).match(p);if(!y)return e;let c=_+(y.index??0);return e.slice(0,_)+e.slice(c)}function Ot(e,s,{guardId:r="",wrapWithMarkers:t=!0}={}){if(!s||t&&r&&it(e,r))return e;let i=s.replace(/\r\n/g,`
`);t&&r&&(i=`;<<< INSERT:${r} START
`+i+`
;>>> INSERT:${r} END
`);let n=e[0]&&e[0]!==`
`?`
`:"";return i+n+e}function Zt(e,s,r,{useRegex:t=!1,occurrence:i="last",guardId:n="",wrapWithMarkers:l=!0}={}){if(!r)return e;let _=t?new RegExp(s,"gm"):new RegExp(`(^|\\n)[ \\t]*${he(s)}[^\\n]*(\\n|$)`,"gm"),p=null;if(i==="first")p=_.exec(e);else{let c,v=null;for(;(c=_.exec(e))!==null&&c[0].length!==0;)v=c;p=v}if(!p)return e;let w=p.index,y=r.replace(/\r\n/g,`
`);if(l&&n){if(it(e,n))return e;y=`;<<< INSERT:${n} START
${y}
;>>> INSERT:${n} END
`}return e.slice(0,w)+y+e.slice(w)}function jt(e,s,r,{useRegex:t=!1,occurrence:i="last",guardId:n="",wrapWithMarkers:l=!0}={}){if(!r)return e;let _=t?new RegExp(s,"gm"):new RegExp(`(^|\\n)[ \\t]*${he(s)}[^\\n]*(\\n|$)`,"gm"),p=null;if(i==="first")p=_.exec(e);else{let c,v=null;for(;(c=_.exec(e))!==null&&c[0].length!==0;)v=c;p=v}if(!p)return e;let w=p.index+p[0].length,y=r.replace(/\r\n/g,`
`);if(l&&n){if(it(e,n))return e;y=`;<<< INSERT:${n} START
${y}
;>>> INSERT:${n} END
`}return e.slice(0,w)+y+e.slice(w)}function Yt(e,s,r,t,{useRegex:i=!1}={}){if(!Array.isArray(t)||t.length===0)return e;let n=i?new RegExp(s,"m"):new RegExp(`(^|\\n)[ \\t]*${he(s)}[^\\n]*\\n`,"m"),l=e.match(n);if(!l)return e;let _=(l.index??0)+l[0].length,p=i?new RegExp(r,"m"):new RegExp(`(^|\\n)[ \\t]*${he(r)}[^\\n]*\\n`,"m"),y=e.slice(_).match(p);if(!y)return e;let c=_+y.index,v=e.slice(0,_),m=e.slice(_,c),F=e.slice(c);for(let h of t){let E=new RegExp(`(^|\\n)[ \\t]*${he(h)}[^
]*(\\n|$)`,"m");m=m.replace(E,"")}return v+m+F}function Ut(e,s){let{start:r,end:t,innerStart:i,innerEnd:n,useRegex:l=!1,innerUseRegex:_=!1}=s,p=Fe(e,r,t,l);if(!p.found)return e;let w=e.slice(0,p.sIdx),y=e.slice(p.sIdx,p.eIdx),c=e.slice(p.eIdx);return y=rt(y,i,n,{useRegex:_}),w+y+c}function $t(e){if(!Array.isArray(e))return e;let s=`
M620 S`,r=[],t=[],i=[];for(let n=0;n<e.length;n++){let l=e[n],_=0;for(;;){let p=l.indexOf(s,_);if(p===-1)break;r.push(p+1),t.push(n);let w=l.substring(p+7,p+10);(w[2]===`
`||w[2]===" ")&&(w=w.substring(0,2));let y=parseInt(w,10);i.push(Number.isFinite(y)?y:NaN),_=p+1}}for(let n=0;n<i.length-1;n++)if(!(n===0||n+1>=i.length)&&i[n]===255&&i[n-1]===i[n+1]){let l=t[n],_=t[n+1],p=r[n],w=r[n+1];e[l]=Nt(e[l],p),e[_]=Nt(e[_],w);try{console.log("AMS swap redundancy removed at pair:",n,"plateA:",l,"plateB:",_)}catch{}}return e}function Nt(e,s){if(s>e.length-1||e.substring(s).indexOf("M621 S")===-1)return e;let i=e.substring(s).search("M621 S");for(var n=";SWAP - AMS block removed";n.length<i-1;)n+="/";return n+=";",n.length>2e3?e:e.substring(0,s)+n+e.substring(s+i)}function qt(e,s,r="gm"){let t=new RegExp(s,r);return e.replace(t,"")}function Wt(e,s,r="gm",t=""){let i=new RegExp(s,r),n=[...e.matchAll(i)];if(n.length===0){if(t){let w=e.endsWith(`
`)?"":`
`;return e+w+t+`
`}return e}if(n.length===1)return e;let l=n[n.length-1],_="",p=0;for(let w=0;w<n.length-1;w++){let y=n[w];_+=e.slice(p,y.index);let c=y[0],v=c.replace(/^/m,"; ");_+=v,p=y.index+c.length}return _+=e.slice(p),_}function it(e,s){return s?new RegExp(`(^|\\n)[ \\t]*;<<< INSERT:${he(s)} START[ \\t]*\\n`,"m").test(e):!1}function Ht(e,s){let r=$.GLOBAL_AMS.overridesPerPlate.get(s)||{};if(!r||Object.keys(r).length===0)return e;function t(n,l){let _=/\bP\d+\b/i.test(l),p=/(?:^|\s)S\d+A\b/i.test(l),w=/(?:^|\s)A\b/i.test(l),{p:y,s:c}=Dt(l),v=`P${y}S${c}`,F=($.GLOBAL_AMS.overridesPerPlate.get(s)||{})[v];if(!F)return`${n}${l}`;let h=/^P(\d+)S(\d+)$/.exec(F);if(!h)return`${n}${l}`;let E=+h[1],g=+h[2],d=l;return d=d.replace(/(\bS)(\d{1,3})(\s*A\b|A\b)?/i,(o,u,b,x)=>x?!/^\s/.test(x)?`${u}${g}A`:`${u}${g} A`:`${u}${g}`),/\bP\d+\b/i.test(d)?d=d.replace(/(\bP)(\d+)\b/i,(o,u,b)=>`${u}${E}`):!_&&E!==0&&(d=` P${E}`+d),`${n}${d}`}let i=e.replace(/^\s*(M620)(?!\.)\b([^\n\r]*)$/gmi,(n,l,_)=>t(l,_));return i=i.replace(/^\s*(M621)(?!\.)\b([^\n\r]*)$/gmi,(n,l,_)=>t(l,_)),i}function Un(e,s){if(!Number.isFinite(e)||e<=1)return"";let r=[200,150,100,50],t=1,i=600,n=1e3,l=2e3,_=v=>(Math.round(v*1e3)/1e3).toString().replace(/(\.\d*?)0+$/,"$1").replace(/\.$/,""),p=[];function w(v){let m=Math.max(t,v);p.push(`;--- PUSH_OFF at Z=${_(m)} mm ---`),p.push(`G1 Z${_(m)} F${i}`);for(let F of r){let h=_(F-8);p.push(`G1 X${h} Y254 F${l}`),p.push(`G1 X${h} Y5   F${n}`),p.push(`G1 X${h} Y254 F${l}`)}}let y=Number.isInteger(s)?Math.max(1,Math.min(10,s)):1;if(y===1)return w(t),p.join(`
`);let c=e/y;for(let v=1;v<y;v++){let m=e-v*c;if(m<=t+1e-6)break;w(m)}return w(t),p.join(`
`)}function $n(e){return!e||!e.length?"":e.map(s=>{let r=(s-8).toFixed(2);return[`G1 X${r} Y254 F2000`,`G1 X${r} Y5 F300`,`G1 X${r} Y254 F2000`].join(`
`)}).join(`
`)}function Jt(e,s){let r=$n(s.coords||[]),t=Je(s.sourcePlateText||e),i="";if(Le()){let n=wt();i=Un(t,n)}return[r,i].filter(Boolean).join(`
`)}function Kt(e,s){let r=s.sourcePlateText||e||"",t=ke(r).header||r,i=Je(t),n=ht(),l=1;return Number.isFinite(i)&&(l=Math.max(1,+(i-n).toFixed(1))),console.log("[raiseBedAfterCooldown] maxZ=",i,"offset=",n,"\u2192 Z=",l),[";=== Raise Bed Level (after cooldown) ===","M400",`G1 Z${l} F600`,"M400 P100"].join(`
`)}function Vt(e,s){let r=gt(),t=Math.max(0,r-5),i=yt(),n=[];n.push("; ====== Cool Down ====="),n.push("M106 P2 S255        ;turn Aux fan on"),n.push("M106 P3 S200        ;turn on chamber cooling fan"),n.push("M400");for(let l=0;l<i;l++)n.push(`M190 S${t} ; wait for bed temp`);return n.push(`; total max wait time of all lines = ${i} min`),n.push("M106 P2 S0         ;turn off Aux fan"),n.push("M106 P3 S0         ;turn off chamber cooling fan"),n.push("M400"),n.push(";>>> Cooldown_fans_wait END"),n.join(`
`)}function Qt(e,s=-1){let r=e.split(/\r?\n/),t=/^\s*G1\b/i,i=/\bX[-+]?\d*\.?\d+/i,n=/\bY[-+]?\d*\.?\d+/i,l=/\bE([-+]?\d*\.?\d+)/i,_=/\bE[-+]?\d*\.?\d+/i,p=-1;for(let w=0;w<r.length;w++){let y=r[w];if(/^\s*;/.test(y))continue;let c=y.split(";",1)[0];if(!t.test(c)||!i.test(c)||!n.test(c))continue;let v=c.match(l);if(!v)continue;let m=parseFloat(v[1]);if(!(!Number.isFinite(m)||m<=0)){p=w;break}}return p===-1?e:(r[p]=r[p].replace(_,"E3"),r.join(`
`))}function tn(e,s,r){let t=ke(e),i=(s||[]).slice().sort((l,_)=>(l.order??100)-(_.order??100));console.log(`[SWAP_RULE] plate=${r.plateIndex} rules order:`,i.map(l=>`${l.order??100}:${l.id}`));let n=(l,_)=>{let p=l,w=_.scope||"body",y={scopeDetails:{}};try{switch(_.action){case"remove_lines_matching":{let c=Pe(l,_.pattern,_.patternFlags||"gm");y.matches=c,p=qt(p,_.pattern,_.patternFlags||"gm");break}case"keep_only_last_matching":{let c=Pe(l,_.pattern,_.patternFlags||"gm");y.matches=c,p=Wt(p,_.pattern,_.patternFlags||"gm",_.appendIfMissing||"");break}case"prepend":{let c=_.payload||"";!c&&_.payloadVar&&(c=nt(_.payloadVar)),y.alreadyInserted=!!(_.wrapWithMarkers!==!1&&_.id&&_alreadyInserted(l,_.id)),y.payloadBytes=(c||"").length,p=Ot(p,c,{guardId:_.id||"",wrapWithMarkers:_.wrapWithMarkers!==!1});break}case"bump_first_extrusion_to_e3":{p=Qt(p,r.plateIndex??-1);break}case"disable_between":{let c=Fe(p,_.start,_.end,!!_.useRegex);y.rangeFound=c.found,p=rt(p,_.start,_.end,{useRegex:!!_.useRegex});break}case"disable_lines":{let c=Fe(p,_.start,_.end,!!_.useRegex);y.rangeFound=c.found,y.lines=(_.lines||[]).length,p=Yt(p,_.start,_.end,_.lines||[],{useRegex:!!_.useRegex});break}case"disable_inner_between":{let c=Fe(p,_.start,_.end,!!_.useRegex);y.outerRangeFound=c.found,y.innerStartSeen=Pe(p,_.innerStart,_.innerUseRegex?"m":"gm")>0,y.innerEndSeen=Pe(p,_.innerEnd,_.innerUseRegex?"m":"gm")>0,p=Ut(p,{start:_.start,end:_.end,useRegex:!!_.useRegex,innerStart:_.innerStart,innerEnd:_.innerEnd,innerUseRegex:!!_.innerUseRegex,allPairs:!0});break}case"insert_after":{let c=_.payload||"";!c&&_.payloadFnId&&(c=en(_.payloadFnId,p,r)),y.anchorFound=tt(p,_.anchor,!!_.useRegex),y.payloadBytes=(c||"").length;let v=p;p=jt(p,_.anchor,c,{useRegex:!!_.useRegex,occurrence:_.occurrence||"last",guardId:_.id||"",wrapWithMarkers:_.wrapWithMarkers!==!1}),p===v&&(y.reason=y.anchorFound?"guardId_alreadyInserted_or_noChange":"anchor_not_found");break}case"insert_before":{let c=_.payload||"";!c&&_.payloadVar&&(c=nt(_.payloadVar)),!c&&_.payloadFnId&&(c=en(_.payloadFnId,p,r)),y.anchorFound=tt(p,_.anchor,!!_.useRegex),y.payloadBytes=(c||"").length;let v=p;p=Zt(p,_.anchor,c,{useRegex:!!_.useRegex,occurrence:_.occurrence||"last",guardId:_.id||"",wrapWithMarkers:_.wrapWithMarkers!==!1}),p===v&&(y.reason=y.anchorFound?"guardId_alreadyInserted_or_noChange":"anchor_not_found");break}default:y.note="unknown_action";break}}catch(c){y.error=c&&c.message?c.message:String(c),console.error("[SWAP_RULE_ERROR]",{id:_.id,action:_.action,scope:w,plate:r.plateIndex,error:y.error})}return It(_,r,w,l,p,y),p};for(let l of i){let _=Rt(l,r);if(_!=="active"){console.debug("[SWAP_RULE] skipped",{id:l.id,action:l.action,plate:r.plateIndex,reason:_,scope:l.scope||"body"});continue}let p=l.scope||"body";if(p==="all"){let w=Ke(t),y=n(w,l);t=ke(y)}else p==="header"?t.header=n(t.header,l):p==="startseq"||p==="start"||p==="start_sequence"?t.startseq=n(t.startseq,l):p==="body"?t.body=n(t.body,l):p==="endseq"||p==="end"||p==="end_sequence"?t.endseq=n(t.endseq,l):console.warn("[SWAP_RULE] unknown scope",{id:l.id,scope:p,plate:r.plateIndex})}return Ke(t)}function en(e,s,r){switch(e){case"raiseBedAfterCoolDown":return Kt(s,r);case"cooldownFansWait":return Vt(s,r);case"buildPushOffPayload":return Jt(s,r);default:return""}}var qn=`;swap ini code
G91 ; 
G0 Z50 F1000; 
G0 Z-20; 
G90; 
G28 XY; 
G0 Y-4 F5000; grab 
G0 Y145;  pull and fix the plate
G0 Y115 F1000; rehook 
G0 Y180 F5000; pull
G4 P500; wait  
G0 Y186.5 F200; fix the plate
G4 P500; wait  
G0 Y3 F15000; back 
G0 Y-5 F200; snap 
G4 P500; wait  
G0 Y10 F1000; load 
G0 Y20 F15000; ready `,Wn=`;swap 
G0 X-10 F5000; 
G0 Z175; 
G0 Y-5 F2000;  
G0 Y186.5 F2000;  
G0 Y182 F10000;  
G0 Z186 ; 
G0 Y120 F500; 
G0 Y-4 Z175 F5000; 
G0 Y145; 
G0 Y115 F1000; 
G0 Y25 F500; 
G0 Y85 F1000; 
G0 Y180 F2000; 
G4 P500; wait  
G0 Y186.5 F200; 
G4 P500; wait  
G0 Y3 F3000; 
G0 Y-5 F200; 
G4 P500; wait  
G0 Y10 F1000; 
G0 Z100 Y186 F2000; 
G0 Y150; 
G4 P1000; wait  `,nn=[{id:"bed_leveling_start_block",description:"Disable bed leveling if plateIndex > 0",enabled:!0,start:";===== bed leveling ==================================",end:";===== bed leveling end ================================",useRegex:!1,scope:"startseq",when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},onlyIf:{plateIndexGreaterThan:0},action:"disable_between"},{id:"disable_filament_purge_after_first",description:"Disable filament purge on all but first plate when option enabled",enabled:!0,order:50,action:"disable_between",start:"M412 S1 ; ===turn on filament runout detection===",end:"M109 S200 ; drop nozzle temp, make filament shink a bit",useRegex:!1,scope:"startseq",when:{modes:["X1","P1"],requireTrue:["opt_filament_purge_off"],requireFalse:[]},onlyIf:{plateIndexGreaterThan:0}},{id:"first_layer_scan",description:"Disable register first layer scan block",enabled:!0,start:";=========register first layer scan=====",end:";=============turn on fans to prevent PLA jamming=================",useRegex:!1,scope:"startseq",when:{modes:["X1"],requireTrue:[],requireFalse:[]},action:"disable_between"},{id:"scanner_clarity",description:"Disable scanner clarity check",enabled:!0,start:";===== check scanner clarity ===========================",end:";===== check scanner clarity end =======================",useRegex:!1,scope:"startseq",when:{modes:["X1"],requireTrue:[],requireFalse:[]},action:"disable_between"},{id:"mech_mode_fast_check",description:"Disable mech mode fast check block",enabled:!0,start:";===== mech mode fast check============================",end:";start heatbed  scan====================================",useRegex:!1,scope:"startseq",when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},onlyIf:{plateIndexGreaterThan:0},action:"disable_between"},{id:"nozzle_load_line_inner",description:"Disable lines between T1000 and M400 within nozzle load line block",enabled:!0,start:";===== nozzle load line ===============================",end:";===== for Textured PEI Plate",useRegex:!1,scope:"startseq",innerStart:"T1000",innerEnd:"M400",innerUseRegex:!1,when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},action:"disable_inner_between"},{id:"extrinsic_para_cali_paint",description:"Disable extrinsic parameter calibration paint",enabled:!0,start:";===== draw extrinsic para cali paint =================",end:";========turn off light and wait extrude temperature =============",useRegex:!1,scope:"startseq",when:{modes:["X1"],requireTrue:[],requireFalse:[]},action:"disable_between"},{id:"purge_line_wipe_nozzle",description:"Disable purge line to wipe the nozzle",enabled:!0,start:";===== purge line to wipe the nozzle ============================",end:"; MACHINE_START_GCODE_END",useRegex:!1,scope:"startseq",when:{modes:["X1"],requireTrue:[],requireFalse:[]},action:"disable_between"},{id:"save_calibration_data",description:"Disable saving calibration data (M973 S4 + M400)",enabled:!0,start:";========turn off light and wait extrude temperature =============",end:";===== purge line to wipe the nozzle ============================",useRegex:!1,scope:"startseq",when:{modes:["X1"],requireTrue:[],requireFalse:[]},action:"disable_lines",lines:["M973 S4 ; turn off scanner","M400 ; wait all motion done before implement the emprical L parameters"]},{id:"lower_print_bed_after_print",description:"Disable lowering of print bed after print",enabled:!0,start:"M17 S",end:"M17 R ; restore z current",useRegex:!1,scope:"endseq",when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},action:"disable_between"},{id:"cooldown_optional_lift",description:"Optional pre-cooldown lift & safety moves",enabled:!0,order:10,action:"insert_after",anchor:"M17 R ; restore z current",occurrence:"last",useRegex:!1,scope:"endseq",wrapWithMarkers:!0,when:{modes:["X1","P1"],requireTrue:["opt_bedlevel_cooling"],requireFalse:[]},payload:`; ====== Cool Down : optional lift =====
  M400                ;wait for all print moves to be done
  M17 Z0.4            ;lower z motor current to reduce impact if there is something in the top
  G1 Z1 F600          ;move nozzle up, BE VERY CAREFUL this can hit the top of your print, extruder or AMS
  M400                ;wait all motion done`},{id:"cooldown_fans_wait",description:"Cool down sequence with fans and timed bed waits",enabled:!0,order:20,action:"insert_after",anchor:"(^|\\n)[ \\t]*;>>> INSERT:cooldown_optional_lift END[ \\t]*(\\n|$)|(^|\\n)[ \\t]*M17 R ; restore z current[ \\t]*(\\n|$)",occurrence:"last",useRegex:!0,scope:"endseq",wrapWithMarkers:!0,when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},payloadFnId:"cooldownFansWait"},{id:"raise_bed_after_cooldown",description:"Raise Bed Level after cooldown using max_z_height",enabled:!0,order:30,action:"insert_after",anchor:";>>> Cooldown_fans_wait END",occurrence:"last",useRegex:!1,scope:"endseq",wrapWithMarkers:!0,when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},payloadFnId:"raiseBedAfterCoolDown"},{id:"push_off_sequence",description:"Insert push-off sequence after raising bed",enabled:!0,order:40,action:"insert_after",anchor:";>>> INSERT:raise_bed_after_cooldown END",occurrence:"last",useRegex:!1,scope:"endseq",wrapWithMarkers:!0,when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},payloadFnId:"buildPushOffPayload"},{id:"m73_drop_nonlast",description:"Disable M73 P100 R0 on all but last plate (X1/P1)",enabled:!0,order:90,scope:"endseq",action:"remove_lines_matching",pattern:`^\\s*M73\\s+P100\\s+R0[^
]*$`,patternFlags:"gmi",when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},onlyIf:{isLastPlate:!1}},{id:"first_extrusion_bump",description:"Raise first extrusion to E3 per plate",enabled:!0,scope:"body",order:80,when:{modes:["X1","P1"],requireTrue:[],requireFalse:[]},action:"bump_first_extrusion_to_e3"},{id:"a1m_prepend_startseg",description:"Insert A1M start segment AFTER ; EXECUTABLE_BLOCK_START on first plate",enabled:!0,order:10,action:"insert_after",scope:"all",useRegex:!0,occurrence:"first",anchor:"(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_START[ \\t]*(\\n|$)",when:{modes:["A1M"],requireTrue:[],requireFalse:[]},onlyIf:{plateIndexEquals:0},payload:qn,wrapWithMarkers:!0},{id:"a1m_append_endseg",description:"Insert A1M end segment BEFORE ; EXECUTABLE_BLOCK_END on every plate",enabled:!0,order:90,action:"insert_before",scope:"all",useRegex:!0,occurrence:"last",anchor:"(^|\\n)[ \\t]*;[ \\t]*EXECUTABLE_BLOCK_END[ \\t]*(\\n|$)",when:{modes:["A1M"],requireTrue:[],requireFalse:[]},payload:Wn,wrapWithMarkers:!0}];function Hn(e,s={}){return{mode:$.CURRENT_MODE,plateIndex:e,totalPlates:s.totalPlates??0,isLastPlate:s.totalPlates?e===s.totalPlates-1:!1,...s}}function Oe(e,s){var r=document.createElement("a");console.log("datafileurl",s),r.setAttribute("href",s),r.setAttribute("download",e),r.style.display="none",document.body.appendChild(r),r.click(),document.body.removeChild(r),console.log("download_started")}function on(e,s){var r=File.prototype.slice||File.prototype.mozSlice||File.prototype.webkitSlice,t=2097152,i=Math.ceil(e.size/t),n=0,l=new an.default.ArrayBuffer,_=new FileReader;_.onload=function(w){if(console.log("read chunk nr",n+1,"of",i),l.append(w.target.result),n++,se(25+50/i*n),n<i)p();else{var y=l.end();console.log("finished loading"),console.info("computed hash",y),s(y)}},_.onerror=function(){console.warn("oops, something went wrong.")};function p(){var w=n*t,y=w+t>=e.size?e.size:w+t;_.readAsArrayBuffer(r.call(e,w,y))}p()}async function Ze({applyRules:e=!0,applyOptimization:s=!0,loopsValue:r,amsOverride:t=!0}={}){let i=$.playlist_ol.getElementsByTagName("li"),n=[],l=[],_=[];for(let h=0;h<i.length;h++){let E=i[h],g=E.getElementsByClassName("f_id")[0].title,d=$.my_files[g],o=E.getElementsByClassName("p_name")[0].title,u=E.getElementsByClassName("p_rep")[0].value*1;if(u>0){let x=await(await rn.default.loadAsync(d)).file(o).async("text"),A=vt(E);for(let I=0;I<u;I++)n.push(x),l.push(A),_.push(h)}}if(n.length===0)return alert("No active plates (Repeats=0)."),se(-1),{empty:!0};let p=$.playlist_ol.getElementsByTagName("li");$.GLOBAL_AMS.overridesPerPlate.clear();for(let h=0;h<p.length;h++){let E=p[h].getElementsByClassName("p_rep")[0];if((parseFloat(E?.value)||0)<=0)continue;let d=Jn(p[h]);Object.keys(d).length&&$.GLOBAL_AMS.overridesPerPlate.set(h,d)}let w=n.length,y=e?n.map((h,E)=>{let g=Hn(E,{totalPlates:w,coords:l[E]||[],sourcePlateText:h});console.log(`
===== RULE PASS for plate ${E+1}/${w} (mode=${$.CURRENT_MODE}) =====`);let d=tn(h,nn||[],g);return t&&(d=Ht(d,_[E])),d}):n.slice(),c=Math.max(1,document.getElementById("loops").value*1||1),v=Array(c).fill(n).flat().join(`
`),m=Array(c).fill(y).flat();s&&(m=$t(m));let F=m.join(`
`);return{empty:!1,platesOnce:n,modifiedPerPlate:y,originalCombined:v,modifiedCombined:F,modifiedLooped:m}}function Jn(e){let s={};return e.querySelectorAll(".p_filament .f_slot").forEach(r=>{let t=parseInt(r?.dataset?.origSlot||"0",10),i=parseInt((r?.textContent||"").trim()||"0",10);if(Number.isFinite(t)&&Number.isFinite(i)&&t>=1&&i>=1&&t!==i){let n=`P0S${t-1}`,l=`P0S${i-1}`;s[n]=l}}),s}var sn=`<?xml version="1.0" encoding="UTF-8"?>
<config>
  <plate>
    <metadata key="plater_id" value="1"/>
    <metadata key="plater_name" value="SWAP"/>
    <metadata key="locked" value="false"/>
    <metadata key="filament_map_mode" value="Auto For Flush"/>
    <metadata key="filament_maps" value="1 1 1"/>
    <metadata key="gcode_file" value="Metadata/plate_1.gcode"/>
    <metadata key="thumbnail_file" value="Metadata/plate_1.png"/>
    <metadata key="thumbnail_no_light_file" value="Metadata/plate_no_light_1.png"/>
    <metadata key="top_file" value="Metadata/top_1.png"/>
    <metadata key="pick_file" value="Metadata/pick_1.png"/>
    <metadata key="pattern_bbox_file" value="Metadata/plate_1.json"/>
  </plate>
</config>`;function je(e){if(/^#([0-9a-f]{3}|[0-9a-f]{6})$/i.test(e))return e;let s=/rgba?\((\d+),\s*(\d+),\s*(\d+)/i.exec(e||"");if(!s)return"#ffffff";let r=t=>("0"+Math.max(0,Math.min(255,+t)).toString(16)).slice(-2);return"#"+r(s[1])+r(s[2])+r(s[3])}function ln(e){let s=/^#?([0-9a-f]{6})$/i.exec(e);if(!s)return[204,204,204];let r=parseInt(s[1],16);return[r>>16&255,r>>8&255,r&255]}function Kn(e,s){let[r,t,i]=ln(e),[n,l,_]=ln(s),p=r-n,w=t-l,y=i-_;return Math.sqrt(p*p+w*w+y*y)}function _n(e,{maxFlush:s=850,minFlush:r=0}={}){let t=e.length,i=Math.sqrt(3*255*255),n=_=>{if(_<=0)return 0;let p=Math.round(r+(s-r)*(_/i));return Math.max(0,Math.min(s,p))},l=[];for(let _=0;_<t;_++)for(let p=0;p<t;p++)l.push(_===p?0:n(Kn(e[_],e[p])));return l}function cn(e,s=140){return Array(Math.max(0,e*2)).fill(String(s))}function Vn(){let s=document.getElementById("filament_total")?.querySelectorAll(":scope > div[title]")||[],r=[];return s.forEach(t=>{let i=parseFloat(t.dataset.used_m||"0")||0,n=parseFloat(t.dataset.used_g||"0")||0;if(i<=0&&n<=0)return;let l=t.querySelector(":scope > .f_color"),_=l?.dataset?.f_color||(l?getComputedStyle(l).backgroundColor:"#cccccc"),p=(je(_)||"#cccccc").toUpperCase();r.push(p)}),r}function Qn(e,s){let r={};for(let[t,i]of Object.entries(e||{}))if(Array.isArray(i)){let n=String(i[0]??"");r[t]=Array(s).fill(n)}else r[t]=i;return r}function un(e,s=er){let r;try{r=JSON.parse(e)}catch(p){console.warn("project_settings original parse failed, fallback to {}:",p),r={}}let t=Vn(),i=t.length;if(i===0)return JSON.stringify(r,null,2);let n=structuredClone?structuredClone(r):JSON.parse(JSON.stringify(r)),l=Qn(s,i);Object.assign(n,l),n.filament_colour=t.slice(),n.filament_multi_colour=t.slice(),n.filament_self_index=Array.from({length:i},(p,w)=>String(w+1));let _=_n(t,{maxFlush:850,minFlush:0});return n.flush_volumes_matrix=_.map(p=>String(p)),n.flush_volumes_vector=cn(i,140),JSON.stringify(n,null,2)}var er={activate_air_filtration:["0"],filament_diameter:["1.75"],additional_cooling_fan_speed:["20"],auxiliary_fan:"1",chamber_temperatures:["0"],filament_adaptive_volumetric_speed:["0"],filament_extruder_variant:["Direct Drive Standard"],circle_compensation_speed:["200"],close_fan_the_first_x_layers:["1"],complete_print_exhaust_fan_speed:["70"],cool_plate_temp:["35"],cool_plate_temp_initial_layer:["35"],counter_coef_1:["0"],counter_coef_2:["0.008"],counter_coef_3:["-0.041"],counter_limit_max:["0.033"],counter_limit_min:["-0.035"],default_filament_colour:[""],diameter_limit:["50"],during_print_exhaust_fan_speed:["70"],enable_overhang_bridge_fan:["1"],enable_pressure_advance:["0"],eng_plate_temp:["0"],eng_plate_temp_initial_layer:["0"],fan_cooling_layer_time:["100"],fan_max_speed:["100"],fan_min_speed:["100"],filament_adhesiveness_category:["100"],filament_change_length:["10"],filament_colour:["#FFFFFF"],filament_colour_type:["1"],filament_cost:["25.4"],filament_density:["1.31"],filament_deretraction_speed:["nil"],filament_end_gcode:[`; filament end gcode 

`],filament_flow_ratio:["0.98"],filament_flush_temp:["0"],filament_flush_volumetric_speed:["0"],filament_ids:["GFL01"],filament_is_support:["0"],filament_long_retractions_when_cut:["nil"],filament_map:["1"],filament_max_volumetric_speed:["22"],filament_minimal_purge_on_wipe_tower:["15"],filament_multi_colour:["#FFFFFF"],filament_notes:"",filament_pre_cooling_temperature:["0"],filament_prime_volume:["45"],filament_printable:["3"],filament_ramming_travel_time:["0"],filament_ramming_volumetric_speed:["-1"],filament_retract_before_wipe:["nil"],filament_retract_restart_extra:["nil"],filament_retract_when_changing_layer:["nil"],filament_retraction_distances_when_cut:["nil"],filament_retraction_length:["nil"],filament_retraction_minimum_travel:["nil"],filament_retraction_speed:["nil"],filament_scarf_gap:["15%"],filament_scarf_height:["10%"],filament_scarf_length:["10"],filament_scarf_seam_type:["none"],filament_self_index:["1","2","3","4"],filament_settings_id:["PolyTerra PLA @BBL X1C"],filament_shrink:["100%"],filament_soluble:["0"],filament_start_gcode:[`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`],filament_type:["PLA"],filament_vendor:["Polymaker"],filament_wipe:["nil"],filament_wipe_distance:["nil"],filament_z_hop:["nil"],filament_z_hop_types:["nil"],hole_coef_1:["0"],hole_coef_2:["-0.008"],hole_coef_3:["0.23415"],hole_limit_max:["0.22"],hole_limit_min:["0.088"],host_type:"octoprint",hot_plate_temp:["55"],hot_plate_temp_initial_layer:["55"],impact_strength_z:["10"],long_retractions_when_ec:["0"],nozzle_temperature:["220"],nozzle_temperature_initial_layer:["220"],nozzle_temperature_range_high:["240"],nozzle_temperature_range_low:["190"],overhang_fan_speed:["100"],overhang_fan_threshold:["50%"],overhang_threshold_participating_cooling:["95%"],pre_start_fan_time:["0"],pressure_advance:["0.02"],reduce_fan_stop_start_freq:["1"],required_nozzle_HRC:["3"],retraction_distances_when_ec:["0"],slow_down_for_layer_cooling:["1"],slow_down_layer_time:["4"],slow_down_min_speed:["20"],supertack_plate_temp:["45"],supertack_plate_temp_initial_layer:["45"],temperature_vitrification:["45"],textured_plate_temp:["55"],textured_plate_temp_initial_layer:["55"],volumetric_speed_coefficients:["0 0 0 0 0 0"],filament_velocity_adaptation_factor:["1"],full_fan_speed_layer:["0"]};async function Ye(){try{if(!Te())return;se(5);let e=await Ze({applyRules:!0,applyOptimization:!0,amsOverride:!0});if(e.empty){alert("Keine aktiven Platten (Repeats=0)."),se(-1);return}let s=new Blob(e.modifiedLooped,{type:"text/x-gcode"});se(25);let r=await at.default.loadAsync($.my_files[0]);r.file(/plate_\d+\.gcode\b$/).forEach(g=>r.remove(g.name)),r.file("Metadata/custom_gcode_per_layer.xml")&&r.remove("Metadata/custom_gcode_per_layer.xml");let n=await(await at.default.loadAsync($.my_files[$.ams_max_file_id])).file("Metadata/project_settings.config").async("text"),l=un(n);r.file("Metadata/project_settings.config",l),r.file("Metadata/model_settings.config",sn);let _=await r.file("Metadata/slice_info.config").async("text"),w=new DOMParser().parseFromString(_,"text/xml"),y=w.getElementsByTagName("plate");for(;y.length>1;)y[y.length-1].remove();let c=y[0].querySelector("[key='index']");c&&c.setAttribute("value","1");let v=y[0].getElementsByTagName("filament");for(;v.length>0;)v[v.length-1].remove();let m=document.getElementById("filament_total")?.querySelectorAll(":scope > div[title]")||[];for(let g=0;g<m.length;g++){let d=m[g],o=parseFloat(d.dataset.used_m||"0")||0,u=parseFloat(d.dataset.used_g||"0")||0;if(o<=0&&u<=0)continue;let b=parseInt(d.getAttribute("title")||`${g+1}`,10)||g+1,x=d.querySelector(":scope > .f_color"),A=x?.dataset?.f_color||(x?getComputedStyle(x).backgroundColor:"#cccccc"),I=je(A||"#cccccc"),W="PLA",G=w.createElement("filament");G.id=String(b),G.setAttribute("type",W),G.setAttribute("color",I),G.setAttribute("used_m",String(o)),G.setAttribute("used_g",String(u)),y[0].appendChild(G)}let h=new XMLSerializer().serializeToString(w);r.file("Metadata/slice_info.config",h.replace(/></g,`>
<`)),r.file("Metadata/plate_1.gcode",s);let E="";await on($.enable_md5?s:new Blob([" "]),async g=>{E=g,r.file("Metadata/plate_1.gcode.md5",E);let d=await r.generateAsync({type:"blob",compression:"DEFLATE",compressionOptions:{level:3}},x=>se(75+Math.floor(20*(x.percent||0)/100))),o=document.getElementById("file_name"),u=(o.value||o.placeholder||"output").trim(),b=URL.createObjectURL(d);Oe(`${u}.swap.3mf`,b),se(100),setTimeout(()=>se(-1),400)})}catch(e){console.error("export_3mf failed:",e),alert("Export fehlgeschlagen: "+(e&&e.message?e.message:e)),se(-1)}}var dn="Please use sliced files in *.3mf or *.gcode.3mf formats. Usage of plane *.gcode files is not supported.",fn=`File not readable. 
`+dn,ze=`No sliced data found. 
`+dn;function tr(e,s,r){e.value==""?trg_val=e.placeholder:trg_val=e.value,e.style.width=Math.min(r,Math.max(s,trg_val.length+2))+"ch"}function Ae(e){var s=$.my_files.length;let r=document.getElementById("file_name");s==0?r.placeholder=e.name.split(".gcode.").join(".").split(".3mf")[0]:r.placeholder="mix",tr(r,5,26),$.my_files.push(e),pn.default.loadAsync(e).then(async function(t){let i=new DOMParser;var n=t.file("Metadata/model_settings.config").async("text"),l=i.parseFromString(await n,"text/xml");let _=l.querySelector("[key='gcode_file']");if(!_){reject_file(ze);return}let p=_.getAttribute("value");if(!p){reject_file(ze);return}let w=await t.file(p).async("text"),y=kt(w);if(Pt(y,e.name)){var c=l.getElementsByTagName("plate");if(c.length==0){reject_file(ze);return}if(c[0].querySelectorAll("[key='gcode_file']").length==0){reject_file(ze);return}document.getElementById("drop_zones_wrapper").classList.add("mini_drop_zone"),document.getElementById("action_buttons").classList.remove("hidden"),document.getElementById("mode_switch").classList.remove("hidden"),document.getElementById("statistics").classList.remove("hidden");for(var v=t.file("Metadata/slice_info.config").async("text"),m=i.parseFromString(await v,"text/xml"),F=0;F<c.length;F++)(function(){let d=c[F].querySelectorAll("[key='gcode_file']")[0].getAttribute("value");if(d!=""){console.log("plate_name found",d);var o=t.file(d);if(o){var u=$.li_prototype.cloneNode(!0);u.removeAttribute("id"),$.playlist_ol.appendChild(u),qe(u),We(u);var b=u.getElementsByClassName("f_name")[0],x=u.getElementsByClassName("p_name")[0],A=u.getElementsByClassName("p_icon")[0],I=u.getElementsByClassName("f_id")[0],W=u.getElementsByClassName("p_time")[0],G=u.getElementsByClassName("p_filaments")[0],B=u.getElementsByClassName("p_filament_prototype")[0];u.classList.remove("hidden"),b.textContent=e.name,b.title=e.name,x.textContent=d.split("Metadata").join("").split(".gcode").join(""),x.title=d,I.title=s,I.innerText="["+s+"]";var f=c[F].querySelectorAll("[key='thumbnail_file']")[0].getAttribute("value");console.log("icon_name",f);var T=t.file(f);console.log("img_file",T),T.async("blob").then(function(J){A.src=URL.createObjectURL(J)});var V="[key='index'][value='"+(F+1)+"']",N=m.querySelectorAll(V);if(N.length>0)var Q=N[0].parentElement.getElementsByTagName("filament");else var Q=m.getElementsByTagName("plate")[0].getElementsByTagName("filament");var Z;for(let J=0;J<Q.length;J++){let X=Q[J],z=X.getAttribute("color")||"#cccccc",H=X.getAttribute("type")||"PLA",U=parseFloat(X.getAttribute("used_m")||"0")||0,O=parseFloat(X.getAttribute("used_g")||"0")||0,ie=X.getAttribute("id"),ae=parseInt(ie,10);Number.isFinite(ae)||(ae=J+1),ae=Math.max(1,Math.min(4,ae));let ee=B.cloneNode(!0);G.appendChild(ee);let ne=ee.getElementsByClassName("f_color")[0];ne.style.backgroundColor=z,ne.dataset.f_color=z;let oe=ee.getElementsByClassName("f_slot")[0];oe.innerText=String(ae),oe.dataset.origSlot=String(ae),oe.dataset.origType=H,ee.getElementsByClassName("f_type")[0].innerText=H,ee.getElementsByClassName("f_used_m")[0].innerText=U.toString(),ee.getElementsByClassName("f_used_g")[0].innerText=O.toString(),ee.className="p_filament"}Ne(u),ge(),Re(u),o.async("string").then(async function(J){let X="total estimated time: ",z=J.indexOf(X)+X.length,H=J.slice(z,J.indexOf(`
`,z));W.innerText=H;var U=0,O=H.match(/\d+[s]/);U=O?parseInt(O):0,O=H.match(/\d+[m]/),U+=(O?parseInt(O):0)*60,O=H.match(/\d+[h]/),U+=(O?parseInt(O):0)*60*60,O=H.match(/\d+[d]/),U+=(O?parseInt(O):0)*60*60*24,W.title=U,de(),console.log("plate_name:"+o.name+" time-string",H)})}}})();var h=m.getElementsByTagName("filament");console.log("filaments.length",h.length);var E=0;console.log("filaments:",h);for(var F=0;F<h.length;F++)h[F].id>E&&(E=h[F].id),console.log("filaments[i].id:",h[F].id),console.log("max_id:",E);$.last_file&&(Ft($.playlist_ol),$.instant_processing&&Ye())}},function(t){var i=document.createElement("div");i.className="alert alert-danger",i.textContent="Error reading "+e.name+": "+t.message,$.err.appendChild(i),reject_file(fn)})}function ot(e,s){e.preventDefault(),Array.from(document.getElementsByClassName("drop_zone_active")).forEach(function(r,t,i){r.classList.remove("drop_zone_active")}),$.instant_processing=s,e.dataTransfer.items?[...e.dataTransfer.items].forEach((r,t)=>{if(r.kind==="file"){let i=r.getAsFile();t+1==e.dataTransfer.items.length?$.last_file=!0:$.last_file=!1,Ae(i)}}):[...e.dataTransfer.files].forEach((r,t)=>{t+1==e.dataTransfer.files.length?$.last_file=!0:$.last_file=!1,Ae(r)})}function Xe(e,s){console.log("File(s) in drop zone"),s.classList.add("drop_zone_active"),e.preventDefault()}function st(e){e.target.classList.remove("drop_zone_active"),e.preventDefault()}var mn=ye(be(),1);async function hn(){if(Te())try{se(5);let{empty:e,platesOnce:s,originalCombined:r,modifiedCombined:t}=await Ze({applyRules:!0,applyOptimization:!0,amsOverride:!0});if(e){alert("Keine aktiven Platten (Repeats=0)."),se(-1);return}se(25);let i=document.getElementById("file_name"),n=(i.value||i.placeholder||"output_file_name").trim(),l=$.CURRENT_MODE||"A1M",_=$.CURRENT_MODE==="X1"||$.CURRENT_MODE==="P1"?$.USE_PURGE_START?"_purge":"_standard":"",p=new Date().toISOString().replace(/[:.]/g,"-"),w=new mn.default,y=w.folder(`${n}_gcode_exports_${l}${_}_${p}`);y.file(`${n}_${l}${_}_original_combined.txt`,r),y.file(`${n}_${l}${_}_modified_combined.txt`,t);let c=y.folder("per_plate_preloop");for(let F=0;F<s.length;F++){let h=String(F+1).padStart(2,"0");c.file(`plate_${h}_original.txt`,s[F])}se(60);let v=await w.generateAsync({type:"blob",compression:"DEFLATE",compressionOptions:{level:3}},F=>{se(60+Math.floor(35*(F.percent||0)/100))}),m=URL.createObjectURL(v);Oe(`${n}_${l}${_}_gcode_exports.zip`,m),se(100),setTimeout(()=>se(-1),500)}catch(e){console.error("GCODE txt export failed:",e),alert("TXT-Export fehlgeschlagen: "+(e.message||e)),se(-1)}}var gn={accel_to_decel_enable:"0",accel_to_decel_factor:"50%",activate_air_filtration:["0","0","0","0"],additional_cooling_fan_speed:["20","20","20","20"],apply_scarf_seam_on_circles:"1",apply_top_surface_compensation:"0",auxiliary_fan:"1",bed_custom_model:"",bed_custom_texture:"",bed_exclude_area:["0x0","18x0","18x28","0x28"],bed_temperature_formula:"by_first_filament",before_layer_change_gcode:"",best_object_pos:"0.5,0.5",bottom_color_penetration_layers:"3",bottom_shell_layers:"3",bottom_shell_thickness:"0",bottom_surface_pattern:"monotonic",bridge_angle:"0",bridge_flow:"1",bridge_no_support:"0",bridge_speed:["50"],brim_object_gap:"0.1",brim_type:"auto_brim",brim_width:"5",chamber_temperatures:["0","0","0","0"],change_filament_gcode:`M620 S[next_extruder]A
M204 S9000
G1 Z{max_layer_z + 3.0} F1200

G1 X70 F21000
G1 Y245
G1 Y265 F3000
M400
M106 P1 S0
M106 P2 S0
{if old_filament_temp > 142 && next_extruder < 255}
M104 S[old_filament_temp]
{endif}
{if long_retractions_when_cut[previous_extruder]}
M620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}
{else}
M620.11 S0
{endif}
M400
G1 X90 F3000
G1 Y255 F4000
G1 X100 F5000
G1 X120 F15000
G1 X20 Y50 F21000
G1 Y-3
{if toolchange_count == 2}
; get travel path for change filament
M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0
M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1
M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2
{endif}
M620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}
T[next_extruder]
M620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}

{if next_extruder < 255}
{if long_retractions_when_cut[previous_extruder]}
M620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}
M628 S1
G92 E0
G1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]
M400
M629 S1
{else}
M620.11 S0
{endif}
G92 E0
{if flush_length_1 > 1}
M83
; FLUSH_START
; always use highest temperature to flush
M400
{if filament_type[next_extruder] == "PETG"}
M109 S260
{elsif filament_type[next_extruder] == "PVA"}
M109 S210
{else}
M109 S[nozzle_temperature_range_high]
{endif}
{if flush_length_1 > 23.7}
G1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
{else}
G1 E{flush_length_1} F{old_filament_e_feedrate}
{endif}
; FLUSH_END
G1 E-[old_retract_length_toolchange] F1800
G1 E[old_retract_length_toolchange] F300
{endif}

{if flush_length_2 > 1}

G91
G1 X3 F12000; move aside to extrude
G90
M83

; FLUSH_START
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
; FLUSH_END
G1 E-[new_retract_length_toolchange] F1800
G1 E[new_retract_length_toolchange] F300
{endif}

{if flush_length_3 > 1}

G91
G1 X3 F12000; move aside to extrude
G90
M83

; FLUSH_START
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
; FLUSH_END
G1 E-[new_retract_length_toolchange] F1800
G1 E[new_retract_length_toolchange] F300
{endif}

{if flush_length_4 > 1}

G91
G1 X3 F12000; move aside to extrude
G90
M83

; FLUSH_START
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
; FLUSH_END
{endif}
; FLUSH_START
M400
M109 S[new_filament_temp]
G1 E2 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature
; FLUSH_END
M400
G92 E0
G1 E-[new_retract_length_toolchange] F1800
M106 P1 S255
M400 S3

G1 X70 F5000
G1 X90 F3000
G1 Y255 F4000
G1 X105 F5000
G1 Y265 F5000
G1 X70 F10000
G1 X100 F5000
G1 X70 F10000
G1 X100 F5000

G1 X70 F10000
G1 X80 F15000
G1 X60
G1 X80
G1 X60
G1 X80 ; shake to put down garbage
G1 X100 F5000
G1 X165 F15000; wipe and shake
G1 Y256 ; move Y to aside, prevent collision
M400
G1 Z{max_layer_z + 3.0} F3000
{if layer_z <= (initial_layer_print_height + 0.001)}
M204 S[initial_layer_acceleration]
{else}
M204 S[default_acceleration]
{endif}
{else}
G1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000
{endif}
M621 S[next_extruder]A
`,circle_compensation_manual_offset:"0",circle_compensation_speed:["200","200","200","200"],close_fan_the_first_x_layers:["1","1","1","1"],complete_print_exhaust_fan_speed:["70","70","70","70"],cool_plate_temp:["35","35","35","35"],cool_plate_temp_initial_layer:["35","35","35","35"],counter_coef_1:["0","0","0","0"],counter_coef_2:["0.008","0.008","0.008","0.008"],counter_coef_3:["-0.041","-0.041","-0.041","-0.041"],counter_limit_max:["0.033","0.033","0.033","0.033"],counter_limit_min:["-0.035","-0.035","-0.035","-0.035"],curr_bed_type:"Textured PEI Plate",default_acceleration:["10000"],default_filament_colour:["","","",""],default_filament_profile:["Bambu PLA Basic @BBL X1C"],default_jerk:"0",default_nozzle_volume_type:["Standard"],default_print_profile:"0.20mm Standard @BBL X1C",deretraction_speed:["30"],detect_floating_vertical_shell:"1",detect_narrow_internal_solid_infill:"1",detect_overhang_wall:"1",detect_thin_wall:"0",diameter_limit:["50","50","50","50"],draft_shield:"disabled",during_print_exhaust_fan_speed:["70","70","70","70"],elefant_foot_compensation:"0.15",enable_arc_fitting:"1",enable_circle_compensation:"0",enable_height_slowdown:["0"],enable_long_retraction_when_cut:"2",enable_overhang_bridge_fan:["1","1","1","1"],enable_overhang_speed:["1"],enable_pre_heating:"0",enable_pressure_advance:["0","0","0","0"],enable_prime_tower:"1",enable_support:"0",enable_wrapping_detection:"0",enforce_support_layers:"0",eng_plate_temp:["0","0","0","0"],eng_plate_temp_initial_layer:["0","0","0","0"],ensure_vertical_shell_thickness:"enabled",exclude_object:"1",extruder_ams_count:["1#0|4#0","1#0|4#0"],extruder_clearance_dist_to_rod:"33",extruder_clearance_height_to_lid:"90",extruder_clearance_height_to_rod:"34",extruder_clearance_max_radius:"68",extruder_colour:["#018001"],extruder_offset:["0x2"],extruder_printable_area:[],extruder_printable_height:[],extruder_type:["Direct Drive"],extruder_variant_list:["Direct Drive Standard"],fan_cooling_layer_time:["100","100","100","100"],fan_max_speed:["100","100","100","100"],fan_min_speed:["100","100","100","100"],filament_adhesiveness_category:["100","100","100","100"],filament_change_length:["10","10","10","10"],filament_colour:["#FFFFFF","#D03535","#59E86A","#CCBF33"],filament_colour_type:["1","1","1","1"],filament_cost:["25.4","25.4","25.4","25.4"],filament_density:["1.31","1.31","1.31","1.31"],filament_deretraction_speed:["nil","nil","nil","nil"],filament_diameter:["1.75","1.75","1.75","1.75"],filament_end_gcode:[`; filament end gcode 

`,`; filament end gcode 

`,`; filament end gcode 

`,`; filament end gcode 

`],filament_extruder_variant:["Direct Drive Standard","Direct Drive Standard","Direct Drive Standard","Direct Drive Standard"],filament_flow_ratio:["0.98","0.98","0.98","0.98"],filament_flush_temp:["0","0","0","0"],filament_flush_volumetric_speed:["0","0","0","0"],filament_ids:["GFL01","GFL01","GFL01","GFL01"],filament_is_support:["0","0","0","0"],filament_long_retractions_when_cut:["nil","nil","nil","nil"],filament_map:["1","1","1","1"],filament_map_mode:"Auto For Flush",filament_max_volumetric_speed:["22","22","22","22"],filament_minimal_purge_on_wipe_tower:["15","15","15","15"],filament_multi_colour:["#FFFFFF","#D03535","#59E86A","#CCBF33"],filament_notes:"",filament_pre_cooling_temperature:["0","0","0","0"],filament_prime_volume:["45","45","45","45"],filament_printable:["3","3","3","3"],filament_ramming_travel_time:["0","0","0","0"],filament_ramming_volumetric_speed:["-1","-1","-1","-1"],filament_retract_before_wipe:["nil","nil","nil","nil"],filament_retract_restart_extra:["nil","nil","nil","nil"],filament_retract_when_changing_layer:["nil","nil","nil","nil"],filament_retraction_distances_when_cut:["nil","nil","nil","nil"],filament_retraction_length:["nil","nil","nil","nil"],filament_retraction_minimum_travel:["nil","nil","nil","nil"],filament_retraction_speed:["nil","nil","nil","nil"],filament_scarf_gap:["15%","15%","15%","15%"],filament_scarf_height:["10%","10%","10%","10%"],filament_scarf_length:["10","10","10","10"],filament_scarf_seam_type:["none","none","none","none"],filament_self_index:["1","2","3","4"],filament_settings_id:["PolyTerra PLA @BBL X1C","PolyTerra PLA @BBL X1C","PolyTerra PLA @BBL X1C","PolyTerra PLA @BBL X1C"],filament_shrink:["100%","100%","100%","100%"],filament_soluble:["0","0","0","0"],filament_start_gcode:[`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`,`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`,`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`,`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`],filament_type:["PLA","PLA","PLA","PLA"],filament_vendor:["Polymaker","Polymaker","Polymaker","Polymaker"],filament_wipe:["nil","nil","nil","nil"],filament_wipe_distance:["nil","nil","nil","nil"],filament_z_hop:["nil","nil","nil","nil"],filament_z_hop_types:["nil","nil","nil","nil"],filename_format:"{input_filename_base}_{filament_type[0]}_{print_time}.gcode",filter_out_gap_fill:"0",first_layer_print_sequence:["0"],flush_into_infill:"0",flush_into_objects:"0",flush_into_support:"1",flush_multiplier:["1"],flush_volumes_matrix:["0","557","432","423","557","0","426","266","432","426","0","258","423","266","258","0"],flush_volumes_vector:["140","140","140","140","140","140","140","140"],from:"project",full_fan_speed_layer:["0","0","0","0"],fuzzy_skin:"none",fuzzy_skin_point_distance:"0.8",fuzzy_skin_thickness:"0.3",gap_infill_speed:["250"],gcode_add_line_number:"0",gcode_flavor:"marlin",grab_length:["0"],has_scarf_joint_seam:"0",head_wrap_detect_zone:[],hole_coef_1:["0","0","0","0"],hole_coef_2:["-0.008","-0.008","-0.008","-0.008"],hole_coef_3:["0.23415","0.23415","0.23415","0.23415"],hole_limit_max:["0.22","0.22","0.22","0.22"],hole_limit_min:["0.088","0.088","0.088","0.088"],host_type:"octoprint",hot_plate_temp:["55","55","55","55"],hot_plate_temp_initial_layer:["55","55","55","55"],hotend_cooling_rate:["2"],hotend_heating_rate:["2"],impact_strength_z:["10","10","10","10"],independent_support_layer_height:"1",infill_combination:"0",infill_direction:"45",infill_jerk:"9",infill_lock_depth:"1",infill_rotate_step:"0",infill_shift_step:"0.4",infill_wall_overlap:"15%",initial_layer_acceleration:["500"],initial_layer_flow_ratio:"1",initial_layer_infill_speed:["105"],initial_layer_jerk:"9",initial_layer_line_width:"0.5",initial_layer_print_height:"0.2",initial_layer_speed:["50"],initial_layer_travel_acceleration:["6000"],inner_wall_acceleration:["0"],inner_wall_jerk:"9",inner_wall_line_width:"0.45",inner_wall_speed:["300"],interface_shells:"0",interlocking_beam:"0",interlocking_beam_layer_count:"2",interlocking_beam_width:"0.8",interlocking_boundary_avoidance:"2",interlocking_depth:"2",interlocking_orientation:"22.5",internal_bridge_support_thickness:"0.8",internal_solid_infill_line_width:"0.42",internal_solid_infill_pattern:"zig-zag",internal_solid_infill_speed:["250"],ironing_direction:"45",ironing_flow:"10%",ironing_inset:"0.21",ironing_pattern:"zig-zag",ironing_spacing:"0.15",ironing_speed:"30",ironing_type:"no ironing",is_infill_first:"0",layer_change_gcode:`; layer num/total_layer_count: {layer_num+1}/[total_layer_count]
; update layer progress
M73 L{layer_num+1}
M991 S0 P{layer_num} ;notify layer change`,layer_height:"0.2",line_width:"0.42",locked_skeleton_infill_pattern:"zigzag",locked_skin_infill_pattern:"crosszag",long_retractions_when_cut:["0"],long_retractions_when_ec:["0","0","0","0"],machine_end_gcode:`;===== date: 20240528 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z{max_layer_z + 0.5} F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom
{if (max_layer_z + 100.0) < 250}
    G1 Z{max_layer_z + 100.0} F600
    G1 Z{max_layer_z +98.0}
{else}
    G1 Z250 F600
    G1 Z248
{endif}
M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0
;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A0 B20 L100 C37 D20 M40 E42 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C46 D10 M80 E46 F10 N80
M1006 A44 B20 L100 C39 D20 M60 E48 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N100
M1006 A49 B20 L100 C44 D20 M100 E41 F20 N100
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N100
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M960 S5 P0 ; turn off logo lamp
`,machine_load_filament_time:"29",machine_max_acceleration_e:["5000","5000"],machine_max_acceleration_extruding:["20000","20000"],machine_max_acceleration_retracting:["5000","5000"],machine_max_acceleration_travel:["9000","9000"],machine_max_acceleration_x:["20000","20000"],machine_max_acceleration_y:["20000","20000"],machine_max_acceleration_z:["500","200"],machine_max_jerk_e:["2.5","2.5"],machine_max_jerk_x:["9","9"],machine_max_jerk_y:["9","9"],machine_max_jerk_z:["3","3"],machine_max_speed_e:["30","30"],machine_max_speed_x:["500","200"],machine_max_speed_y:["500","200"],machine_max_speed_z:["20","20"],machine_min_extruding_rate:["0","0"],machine_min_travel_rate:["0","0"],machine_pause_gcode:"M400 U1",machine_prepare_compensation_time:"260",machine_start_gcode:`;===== machine: X1 ====================
;===== date: 20240919 ==================
;===== start printer sound ================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A46 B10 L100 C43 D10 M70 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A43 B10 L100 C0 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A41 B10 L100 C0 D10 M100 E41 F10 N100
M1006 A44 B10 L100 C0 D10 M100 E44 F10 N100
M1006 A49 B10 L100 C0 D10 M100 E49 F10 N100
M1006 A0 B10 L100 C0 D10 M100 E0 F10 N100
M1006 A48 B10 L100 C44 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A44 B10 L100 C0 D10 M90 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A46 B10 L100 C43 D10 M60 E39 F10 N100
M1006 W
;===== turn on the HB fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
;===== reset machine status =================
M290 X40 Y40 Z2.6666666
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z{+0.0} ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;===== heatbed preheat ====================
M1002 gcode_claim_action : 2
M140 S[bed_temperature_initial_layer_single] ;set bed temp
M190 S[bed_temperature_initial_layer_single] ;wait for bed temp

{if scan_first_layer}
;=========register first layer scan=====
M977 S1 P60
{endif}

;=============turn on fans to prevent PLA jamming=================
{if filament_type[initial_no_support_extruder]=="PLA"}
    {if (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}
    M106 P3 S180
    {endif};Prevent PLA from jamming
    M142 P1 R35 S40
{endif}
M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S[nozzle_temperature_initial_layer] ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S[initial_no_support_extruder]A   ; switch material if AMS exist
    M109 S[nozzle_temperature_initial_layer]
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T[initial_no_support_extruder]
    G1 X54 F12000
    G1 Y265
    M400
M621 S[initial_no_support_extruder]A
M620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]}

M412 S1 ; ===turn on filament runout detection===

M109 S250 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
G1 E50 F200
M400
M104 S[nozzle_temperature_initial_layer]
G92 E0
G1 E50 F200
M400
M106 P1 S255
G92 E0
G1 E5 F300
M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20} ; drop nozzle temp, make filament shink a bit
G92 E0
G1 E-0.5 F300

G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000; wipe and shake
M400
M106 P1 S0
;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20}
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
G1 X100 F5000; second wipe mouth
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
G1 Z10
G1 F30000
G1 X128 Y128
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================

;===== check scanner clarity ===========================
G1 X128 Y128 F24000
G28 Z P0
M972 S5 P0
G1 X230 Y15 F24000
;===== check scanner clarity end =======================

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag
M622 J1

    M1002 gcode_claim_action : 1
    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
    M400
    M500 ; save cali data

M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623
;===== home after wipe mouth end =======================

M975 S1 ; turn on vibration supression

;=============turn on fans to prevent PLA jamming=================
{if filament_type[initial_no_support_extruder]=="PLA"}
    {if (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}
    M106 P3 S180
    {endif};Prevent PLA from jamming
    M142 P1 R35 S40
{endif}
M106 P2 S100 ; turn on big fan ,to cool down toolhead

M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================
G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q1 A7 B30 C80  H15 K0
M974 Q1 S2 P0

G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q0 A7 B30 C90 Q0 H15 K0
M974 Q0 S2 P0

M975 S1
G1 F30000
G1 X230 Y15
G28 X ; re-home XY
;===== mech mode fast check============================

{if scan_first_layer}
;start heatbed  scan====================================
M976 S2 P1
G90
G1 X128 Y128 F20000
M976 S3 P2  ;register void printing detection
{endif}

;===== nozzle load line ===============================
M975 S1
G90
M83
T1000
G1 X18.0 Y1.0 Z0.8 F18000;Move to start position
M109 S{nozzle_temperature[initial_no_support_extruder]}
G1 Z0.2
G0 E2 F300
G0 X240 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
G0 Y11 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
G0 X239.5
G0 E0.2
G0 Y1.5 E0.700
G0 X231 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type={curr_bed_type}
{if curr_bed_type=="Textured PEI Plate"}
G29.1 Z{-0.04} ; for Textured PEI Plate
{endif}

;===== draw extrinsic para cali paint =================
M1002 judge_flag extrude_cali_flag
M622 J1

    M1002 gcode_claim_action : 8

    T1000

    G0 F1200.0 X231 Y15   Z0.2 E0.741
    G0 F1200.0 X226 Y15   Z0.2 E0.275
    G0 F1200.0 X226 Y8    Z0.2 E0.384
    G0 F1200.0 X216 Y8    Z0.2 E0.549
    G0 F1200.0 X216 Y1.5  Z0.2 E0.357

    G0 X48.0 E12.0 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X48.0 Y14 E0.92 F1200.0
    G0 X35.0 Y6.0 E1.03 F1200.0

    ;=========== extruder cali extrusion ==================
    T1000
    M83
    {if default_acceleration > 0}
        {if outer_wall_acceleration > 0}
            M204 S[outer_wall_acceleration]
        {else}
            M204 S[default_acceleration]
        {endif}
    {endif}
    G0 X35.000 Y6.000 Z0.300 F30000 E0
    G1 F1500.000 E0.800
    M106 S0 ; turn off fan
    G0 X185.000 E9.35441 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G0 X187 Z0
    G1 F1500.000 E-0.800
    G0 Z1
    G0 X180 Z0.3 F18000

    M900 L1000.0 M1.0
    M900 K0.040
    G0 X45.000 F30000
    G0 Y8.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3
    M400

    G0 X45.000 F30000
    M900 K0.020
    G0 X45.000 F30000
    G0 Y10.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3
    M400

    G0 X45.000 F30000
    M900 K0.000
    G0 X45.000 F30000
    G0 Y12.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3

    G0 X45.000 F30000 ; move to start point

M623 ; end of "draw extrinsic para cali paint"


M1002 judge_flag extrude_cali_flag
M622 J0
    G0 X231 Y1.5 F30000
    G0 X18 E14.3 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
M623

M104 S140


;=========== laser and rgb calibration ===========
M400
M18 E
M500 R

M973 S3 P14

G1 X120 Y1.0 Z0.3 F18000.0;Move to first extrude line pos
T1100
G1 X235.0 Y1.0 Z0.3 F18000.0;Move to first extrude line pos
M400 P100
M960 S1 P1
M400 P100
M973 S6 P0; use auto exposure for horizontal laser by xcam
M960 S0 P0

G1 X240.0 Y6.0 Z0.3 F18000.0;Move to vertical extrude line pos
M960 S2 P1
M400 P100
M973 S6 P1; use auto exposure for vertical laser by xcam
M960 S0 P0

;=========== handeye calibration ======================
M1002 judge_flag extrude_cali_flag
M622 J1

    M973 S3 P1 ; camera start stream
    M400 P500
    M973 S1
    G0 F6000 X228.500 Y4.500 Z0.000
    M960 S0 P1
    M973 S1
    M400 P800
    M971 S6 P0
    M973 S2 P0
    M400 P500
    G0 Z0.000 F12000
    M960 S0 P0
    M960 S1 P1
    G0 X221.00 Y4.50
    M400 P200
    M971 S5 P1
    M973 S2 P1
    M400 P500
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y11.0
    M400 P200
    M971 S5 P3
    G0 Z0.500 F12000
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y11.0
    M400 P200
    M971 S5 P4
    M973 S2 P0
    M400 P500
    M960 S0 P0
    M960 S1 P1
    G0 X221.00 Y4.50
    M400 P500
    M971 S5 P2
    M963 S1
    M400 P1500
    M964
    T1100
    G0 F6000 X228.500 Y4.500 Z0.000
    M960 S0 P1
    M973 S1
    M400 P800
    M971 S6 P0
    M973 S2 P0
    M400 P500
    G0 Z0.000 F12000
    M960 S0 P0
    M960 S1 P1
    G0 X221.00 Y4.50
    M400 P200
    M971 S5 P1
    M973 S2 P1
    M400 P500
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y11.0
    M400 P200
    M971 S5 P3
    G0 Z0.500 F12000
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y11.0
    M400 P200
    M971 S5 P4
    M973 S2 P0
    M400 P500
    M960 S0 P0
    M960 S1 P1
    G0 X221.00 Y4.50
    M400 P500
    M971 S5 P2
    M963 S1
    M400 P1500
    M964
    T1100
    G1 Z3 F3000

    M400
    M500 ; save cali data

    M104 S{nozzle_temperature[initial_no_support_extruder]} ; rise nozzle temp now ,to reduce temp waiting time.

    T1100
    M400 P400
    M960 S0 P0
    G0 F30000.000 Y10.000 X65.000 Z0.000
    M400 P400
    M960 S1 P1
    M400 P50

    M969 S1 N3 A2000
    G0 F360.000 X181.000 Z0.000
    M980.3 A70.000 B{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60/4} C5.000 D{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60} E5.000 F175.000 H1.000 I0.000 J0.020 K0.040
    M400 P100
    G0 F20000
    G0 Z1 ; rise nozzle up
    T1000 ; change to nozzle space
    G0 X45.000 Y4.000 F30000 ; move to test line pos
    M969 S0 ; turn off scanning
    M960 S0 P0


    G1 Z2 F20000
    T1000
    G0 X45.000 Y4.000 F30000 E0
    M109 S{nozzle_temperature[initial_no_support_extruder]}
    G0 Z0.3
    G1 F1500.000 E3.600
    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}

    ; see if extrude cali success, if not ,use default value
    M1002 judge_last_extrude_cali_success
    M622 J0
        M400
        M900 K0.02 M{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*0.02}
    M623

    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X185.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X190.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X195.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X200.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X205.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X210.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X215.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X220.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X225.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    M973 S4

M623

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M973 S4 ; turn off scanner
M400 ; wait all motion done before implement the emprical L parameters
;M900 L500.0 ; Empirical parameters
M109 S[nozzle_temperature_initial_layer]
M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000
;===== purge line to wipe the nozzle ============================
G1 E{-retraction_length[initial_no_support_extruder]} F1800
G1 X18.0 Y2.5 Z0.8 F18000.0;Move to start position
G1 E{retraction_length[initial_no_support_extruder]} F1800
M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}
G1 Z0.2
G0 X239 E15 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
G0 Y12 E0.7 F{outer_wall_volumetric_speed/(0.3*0.5)/4* 60}
`,machine_switch_extruder_time:"0",machine_unload_filament_time:"28",master_extruder_id:"1",max_bridge_length:"0",max_layer_height:["0.28"],max_travel_detour_distance:"0",min_bead_width:"85%",min_feature_size:"25%",min_layer_height:["0.08"],minimum_sparse_infill_area:"15",mmu_segmented_region_interlocking_depth:"0",mmu_segmented_region_max_width:"0",name:"project_settings",nozzle_diameter:["0.4"],nozzle_flush_dataset:["0"],nozzle_height:"4.2",nozzle_temperature:["220","220","220","220"],nozzle_temperature_initial_layer:["220","220","220","220"],nozzle_temperature_range_high:["240","240","240","240"],nozzle_temperature_range_low:["190","190","190","190"],nozzle_type:["hardened_steel"],nozzle_volume:["107"],nozzle_volume_type:["Standard"],only_one_wall_first_layer:"0",ooze_prevention:"0",other_layers_print_sequence:["0"],other_layers_print_sequence_nums:"0",outer_wall_acceleration:["5000"],outer_wall_jerk:"9",outer_wall_line_width:"0.42",outer_wall_speed:["200"],overhang_1_4_speed:["0"],overhang_2_4_speed:["50"],overhang_3_4_speed:["30"],overhang_4_4_speed:["10"],overhang_fan_speed:["100","100","100","100"],overhang_fan_threshold:["50%","50%","50%","50%"],overhang_threshold_participating_cooling:["95%","95%","95%","95%"],overhang_totally_speed:["10"],override_filament_scarf_seam_setting:"0",physical_extruder_map:["0"],post_process:[],pre_start_fan_time:["0","0","0","0"],precise_outer_wall:"0",precise_z_height:"0",pressure_advance:["0.02","0.02","0.02","0.02"],prime_tower_brim_width:"3",prime_tower_enable_framework:"0",prime_tower_extra_rib_length:"0",prime_tower_fillet_wall:"1",prime_tower_flat_ironing:"0",prime_tower_infill_gap:"150%",prime_tower_lift_height:"-1",prime_tower_lift_speed:"90",prime_tower_max_speed:"90",prime_tower_rib_wall:"1",prime_tower_rib_width:"8",prime_tower_skip_points:"1",prime_tower_width:"35",print_compatible_printers:["Bambu Lab X1 Carbon 0.4 nozzle","Bambu Lab X1 0.4 nozzle","Bambu Lab P1S 0.4 nozzle","Bambu Lab X1E 0.4 nozzle"],print_extruder_id:["1"],print_extruder_variant:["Direct Drive Standard"],print_flow_ratio:"1",print_sequence:"by layer",print_settings_id:"0.20mm Standard @BBL X1C",printable_area:["0x0","256x0","256x256","0x256"],printable_height:"250",printer_extruder_id:["1"],printer_extruder_variant:["Direct Drive Standard"],printer_model:"Bambu Lab X1 Carbon",printer_notes:"",printer_settings_id:"Bambu Lab X1 Carbon 0.4 nozzle",printer_structure:"corexy",printer_technology:"FFF",printer_variant:"0.4",printhost_authorization_type:"key",printhost_ssl_ignore_revoke:"0",printing_by_object_gcode:"",process_notes:"",raft_contact_distance:"0.1",raft_expansion:"1.5",raft_first_layer_density:"90%",raft_first_layer_expansion:"-1",raft_layers:"0",reduce_crossing_wall:"0",reduce_fan_stop_start_freq:["1","1","1","1"],reduce_infill_retraction:"1",required_nozzle_HRC:["3","3","3","3"],resolution:"0.012",retract_before_wipe:["0%"],retract_length_toolchange:["2"],retract_lift_above:["0"],retract_lift_below:["249"],retract_restart_extra:["0"],retract_restart_extra_toolchange:["0"],retract_when_changing_layer:["1"],retraction_distances_when_cut:["18"],retraction_distances_when_ec:["0","0","0","0"],retraction_length:["0.8"],retraction_minimum_travel:["1"],retraction_speed:["30"],role_base_wipe_speed:"1",scan_first_layer:"1",scarf_angle_threshold:"155",seam_gap:"15%",seam_placement_away_from_overhangs:"0",seam_position:"aligned",seam_slope_conditional:"1",seam_slope_entire_loop:"0",seam_slope_gap:"0",seam_slope_inner_walls:"1",seam_slope_min_length:"10",seam_slope_start_height:"10%",seam_slope_steps:"10",seam_slope_type:"none",silent_mode:"0",single_extruder_multi_material:"1",skeleton_infill_density:"15%",skeleton_infill_line_width:"0.45",skin_infill_density:"15%",skin_infill_depth:"2",skin_infill_line_width:"0.45",skirt_distance:"2",skirt_height:"1",skirt_loops:"0",slice_closing_radius:"0.049",slicing_mode:"regular",slow_down_for_layer_cooling:["1","1","1","1"],slow_down_layer_time:["4","4","4","4"],slow_down_min_speed:["20","20","20","20"],slowdown_end_acc:["100000"],slowdown_end_height:["400"],slowdown_end_speed:["1000"],slowdown_start_acc:["100000"],slowdown_start_height:["0"],slowdown_start_speed:["1000"],small_perimeter_speed:["50%"],small_perimeter_threshold:["0"],smooth_coefficient:"150",smooth_speed_discontinuity_area:"1",solid_infill_filament:"1",sparse_infill_acceleration:["100%"],sparse_infill_anchor:"400%",sparse_infill_anchor_max:"20",sparse_infill_density:"15%",sparse_infill_filament:"1",sparse_infill_line_width:"0.45",sparse_infill_pattern:"grid",sparse_infill_speed:["270"],spiral_mode:"0",spiral_mode_max_xy_smoothing:"200%",spiral_mode_smooth:"0",standby_temperature_delta:"-5",start_end_points:["30x-3","54x245"],supertack_plate_temp:["45","45","45","45"],supertack_plate_temp_initial_layer:["45","45","45","45"],support_air_filtration:"0",support_angle:"0",support_base_pattern:"default",support_base_pattern_spacing:"2.5",support_bottom_interface_spacing:"0.5",support_bottom_z_distance:"0.2",support_chamber_temp_control:"0",support_critical_regions_only:"0",support_expansion:"0",support_filament:"0",support_interface_bottom_layers:"2",support_interface_filament:"0",support_interface_loop_pattern:"0",support_interface_not_for_body:"1",support_interface_pattern:"auto",support_interface_spacing:"0.5",support_interface_speed:["80"],support_interface_top_layers:"2",support_line_width:"0.42",support_object_first_layer_gap:"0.2",support_object_xy_distance:"0.35",support_on_build_plate_only:"0",support_remove_small_overhang:"1",support_speed:["150"],support_style:"default",support_threshold_angle:"30",support_top_z_distance:"0.2",support_type:"tree(auto)",symmetric_infill_y_axis:"0",temperature_vitrification:["45","45","45","45"],template_custom_gcode:"",textured_plate_temp:["55","55","55","55"],textured_plate_temp_initial_layer:["55","55","55","55"],thick_bridges:"0",thumbnail_size:["50x50"],time_lapse_gcode:`;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
{if timelapse_type == 0} ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter
{elsif timelapse_type == 1} ; timelapse with wipe tower
G92 E0
G1 X65 Y245 F20000 ; move to safe pos
G17
G2 Z{layer_z} I0.86 J0.86 P1 F20000
G1 Y265 F3000
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C10 O0
G92 E0
G1 X100 F5000
G1 Y255 F20000
{endif}
M623
; SKIPPABLE_END
`,timelapse_type:"0",top_area_threshold:"200%",top_color_penetration_layers:"5",top_one_wall_type:"all top",top_shell_layers:"5",top_shell_thickness:"1",top_solid_infill_flow_ratio:"1",top_surface_acceleration:["2000"],top_surface_jerk:"9",top_surface_line_width:"0.42",top_surface_pattern:"monotonicline",top_surface_speed:["200"],travel_acceleration:["10000"],travel_jerk:"9",travel_speed:["500"],travel_speed_z:["0"],tree_support_branch_angle:"45",tree_support_branch_diameter:"2",tree_support_branch_diameter_angle:"5",tree_support_branch_distance:"5",tree_support_wall_count:"-1",upward_compatible_machine:["Bambu Lab P1S 0.4 nozzle","Bambu Lab P1P 0.4 nozzle","Bambu Lab X1 0.4 nozzle","Bambu Lab X1E 0.4 nozzle","Bambu Lab A1 0.4 nozzle","Bambu Lab H2D 0.4 nozzle","Bambu Lab H2D Pro 0.4 nozzle"],use_firmware_retraction:"0",use_relative_e_distances:"1",version:"02.02.00.85",vertical_shell_speed:["80%"],wall_distribution_count:"1",wall_filament:"1",wall_generator:"classic",wall_loops:"2",wall_sequence:"inner wall/outer wall",wall_transition_angle:"10",wall_transition_filter_deviation:"25%",wall_transition_length:"100%",wipe:["1"],wipe_distance:["2"],wipe_speed:"80%",wipe_tower_no_sparse_layers:"0",wipe_tower_rotation_angle:"0",wipe_tower_x:["165"],wipe_tower_y:["216.972"],wrapping_detection_gcode:"",wrapping_detection_layers:"20",wrapping_exclude_area:[],xy_contour_compensation:"0",xy_hole_compensation:"0",z_direction_outwall_speed_continuous:"0",z_hop:["0.4"],z_hop_types:["Auto Lift"],filament_adaptive_volumetric_speed:["0","0","0","0"],volumetric_speed_coefficients:["0 0 0 0 0 0","0 0 0 0 0 0","0 0 0 0 0 0","0 0 0 0 0 0"],filament_velocity_adaptation_factor:["1","1","1","1"]};var wn={accel_to_decel_enable:"0",accel_to_decel_factor:"50%",activate_air_filtration:["0","0","0","0"],additional_cooling_fan_speed:["70","70","70","70"],apply_scarf_seam_on_circles:"1",apply_top_surface_compensation:"0",auxiliary_fan:"1",bed_custom_model:"",bed_custom_texture:"",bed_exclude_area:["0x0","18x0","18x28","0x28"],bed_temperature_formula:"by_first_filament",before_layer_change_gcode:"",best_object_pos:"0.5,0.5",bottom_color_penetration_layers:"3",bottom_shell_layers:"3",bottom_shell_thickness:"0",bottom_surface_pattern:"monotonic",bridge_angle:"0",bridge_flow:"1",bridge_no_support:"0",bridge_speed:["50"],brim_object_gap:"0.1",brim_type:"auto_brim",brim_width:"5",chamber_temperatures:["0","0","0","0"],change_filament_gcode:`M620 S[next_extruder]A
M204 S9000
G1 Z{max_layer_z + 3.0} F1200

G1 X70 F21000
G1 Y245
G1 Y265 F3000
M400
M106 P1 S0
M106 P2 S0
{if old_filament_temp > 142 && next_extruder < 255}
M104 S[old_filament_temp]
{endif}
{if long_retractions_when_cut[previous_extruder]}
M620.11 S1 I[previous_extruder] E-{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}
{else}
M620.11 S0
{endif}
M400
G1 X90 F3000
G1 Y255 F4000
G1 X100 F5000
G1 X120 F15000
G1 X20 Y50 F21000
G1 Y-3
{if toolchange_count == 2}
; get travel path for change filament
M620.1 X[travel_point_1_x] Y[travel_point_1_y] F21000 P0
M620.1 X[travel_point_2_x] Y[travel_point_2_y] F21000 P1
M620.1 X[travel_point_3_x] Y[travel_point_3_y] F21000 P2
{endif}
M620.1 E F[old_filament_e_feedrate] T{nozzle_temperature_range_high[previous_extruder]}
T[next_extruder]
M620.1 E F[new_filament_e_feedrate] T{nozzle_temperature_range_high[next_extruder]}

{if next_extruder < 255}
{if long_retractions_when_cut[previous_extruder]}
M620.11 S1 I[previous_extruder] E{retraction_distances_when_cut[previous_extruder]} F{old_filament_e_feedrate}
M628 S1
G92 E0
G1 E{retraction_distances_when_cut[previous_extruder]} F[old_filament_e_feedrate]
M400
M629 S1
{else}
M620.11 S0
{endif}
G92 E0
{if flush_length_1 > 1}
M83
; FLUSH_START
; always use highest temperature to flush
M400
{if filament_type[next_extruder] == "PETG"}
M109 S260
{elsif filament_type[next_extruder] == "PVA"}
M109 S210
{else}
M109 S[nozzle_temperature_range_high]
{endif}
{if flush_length_1 > 23.7}
G1 E23.7 F{old_filament_e_feedrate} ; do not need pulsatile flushing for start part
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{old_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
G1 E{(flush_length_1 - 23.7) * 0.02} F50
G1 E{(flush_length_1 - 23.7) * 0.23} F{new_filament_e_feedrate}
{else}
G1 E{flush_length_1} F{old_filament_e_feedrate}
{endif}
; FLUSH_END
G1 E-[old_retract_length_toolchange] F1800
G1 E[old_retract_length_toolchange] F300
{endif}

{if flush_length_2 > 1}

G91
G1 X3 F12000; move aside to extrude
G90
M83

; FLUSH_START
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
G1 E{flush_length_2 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_2 * 0.02} F50
; FLUSH_END
G1 E-[new_retract_length_toolchange] F1800
G1 E[new_retract_length_toolchange] F300
{endif}

{if flush_length_3 > 1}

G91
G1 X3 F12000; move aside to extrude
G90
M83

; FLUSH_START
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
G1 E{flush_length_3 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_3 * 0.02} F50
; FLUSH_END
G1 E-[new_retract_length_toolchange] F1800
G1 E[new_retract_length_toolchange] F300
{endif}

{if flush_length_4 > 1}

G91
G1 X3 F12000; move aside to extrude
G90
M83

; FLUSH_START
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
G1 E{flush_length_4 * 0.18} F{new_filament_e_feedrate}
G1 E{flush_length_4 * 0.02} F50
; FLUSH_END
{endif}
; FLUSH_START
M400
M109 S[new_filament_temp]
G1 E2 F{new_filament_e_feedrate} ;Compensate for filament spillage during waiting temperature
; FLUSH_END
M400
G92 E0
G1 E-[new_retract_length_toolchange] F1800
M106 P1 S255
M400 S3

G1 X70 F5000
G1 X90 F3000
G1 Y255 F4000
G1 X105 F5000
G1 Y265 F5000
G1 X70 F10000
G1 X100 F5000
G1 X70 F10000
G1 X100 F5000

G1 X70 F10000
G1 X80 F15000
G1 X60
G1 X80
G1 X60
G1 X80 ; shake to put down garbage
G1 X100 F5000
G1 X165 F15000; wipe and shake
G1 Y256 ; move Y to aside, prevent collision
M400
G1 Z{max_layer_z + 3.0} F3000
{if layer_z <= (initial_layer_print_height + 0.001)}
M204 S[initial_layer_acceleration]
{else}
M204 S[default_acceleration]
{endif}
{else}
G1 X[x_after_toolchange] Y[y_after_toolchange] Z[z_after_toolchange] F12000
{endif}
M621 S[next_extruder]A
`,circle_compensation_manual_offset:"0",circle_compensation_speed:["200","200","200","200"],close_fan_the_first_x_layers:["1","1","1","1"],complete_print_exhaust_fan_speed:["70","70","70","70"],cool_plate_temp:["35","35","35","35"],cool_plate_temp_initial_layer:["35","35","35","35"],counter_coef_1:["0","0","0","0"],counter_coef_2:["0.008","0.008","0.008","0.008"],counter_coef_3:["-0.041","-0.041","-0.041","-0.041"],counter_limit_max:["0.033","0.033","0.033","0.033"],counter_limit_min:["-0.035","-0.035","-0.035","-0.035"],curr_bed_type:"Textured PEI Plate",default_acceleration:["10000"],default_filament_colour:["","","",""],default_filament_profile:["Bambu PLA Basic @BBL X1C"],default_jerk:"0",default_nozzle_volume_type:["Standard"],default_print_profile:"0.20mm Standard @BBL X1C",deretraction_speed:["30"],detect_floating_vertical_shell:"1",detect_narrow_internal_solid_infill:"1",detect_overhang_wall:"1",detect_thin_wall:"0",diameter_limit:["50","50","50","50"],draft_shield:"disabled",during_print_exhaust_fan_speed:["70","70","70","70"],elefant_foot_compensation:"0.15",enable_arc_fitting:"1",enable_circle_compensation:"0",enable_height_slowdown:["0"],enable_long_retraction_when_cut:"2",enable_overhang_bridge_fan:["1","1","1","1"],enable_overhang_speed:["1"],enable_pre_heating:"0",enable_pressure_advance:["0","0","0","0"],enable_prime_tower:"1",enable_support:"0",enable_wrapping_detection:"0",enforce_support_layers:"0",eng_plate_temp:["0","0","0","0"],eng_plate_temp_initial_layer:["0","0","0","0"],ensure_vertical_shell_thickness:"enabled",exclude_object:"1",extruder_ams_count:["1#0|4#0","1#0|4#0"],extruder_clearance_dist_to_rod:"33",extruder_clearance_height_to_lid:"90",extruder_clearance_height_to_rod:"34",extruder_clearance_max_radius:"68",extruder_colour:["#018001"],extruder_offset:["0x2"],extruder_printable_area:[],extruder_printable_height:[],extruder_type:["Direct Drive"],extruder_variant_list:["Direct Drive Standard"],fan_cooling_layer_time:["100","100","100","100"],fan_max_speed:["100","100","100","100"],fan_min_speed:["100","100","100","100"],filament_adaptive_volumetric_speed:["0","0","0","0"],filament_adhesiveness_category:["100","100","100","100"],filament_change_length:["10","10","10","10"],filament_colour:["#FCECD6","#FFFFFF","#161616","#C0C0C0"],filament_colour_type:["0","0","0","1"],filament_cost:["25.4","25.4","25.4","25.4"],filament_density:["1.31","1.31","1.31","1.31"],filament_deretraction_speed:["nil","nil","nil","nil"],filament_diameter:["1.75","1.75","1.75","1.75"],filament_end_gcode:[`; filament end gcode 

`,`; filament end gcode 

`,`; filament end gcode 

`,`; filament end gcode 

`],filament_extruder_variant:["Direct Drive Standard","Direct Drive Standard","Direct Drive Standard","Direct Drive Standard"],filament_flow_ratio:["0.98","0.98","0.98","0.98"],filament_flush_temp:["0","0","0","0"],filament_flush_volumetric_speed:["0","0","0","0"],filament_ids:["GFL01","GFL01","GFL01","GFL01"],filament_is_support:["0","0","0","0"],filament_long_retractions_when_cut:["nil","nil","nil","nil"],filament_map:["1","1","1","1"],filament_map_mode:"Auto For Flush",filament_max_volumetric_speed:["22","22","22","22"],filament_minimal_purge_on_wipe_tower:["15","15","15","15"],filament_multi_colour:["#FCECD6","#FFFFFF","#161616","#C0C0C0"],filament_notes:"",filament_pre_cooling_temperature:["0","0","0","0"],filament_prime_volume:["45","45","45","45"],filament_printable:["3","3","3","3"],filament_ramming_travel_time:["0","0","0","0"],filament_ramming_volumetric_speed:["-1","-1","-1","-1"],filament_retract_before_wipe:["nil","nil","nil","nil"],filament_retract_restart_extra:["nil","nil","nil","nil"],filament_retract_when_changing_layer:["nil","nil","nil","nil"],filament_retraction_distances_when_cut:["nil","nil","nil","nil"],filament_retraction_length:["nil","nil","nil","nil"],filament_retraction_minimum_travel:["nil","nil","nil","nil"],filament_retraction_speed:["nil","nil","nil","nil"],filament_scarf_gap:["15%","15%","15%","15%"],filament_scarf_height:["10%","10%","10%","10%"],filament_scarf_length:["10","10","10","10"],filament_scarf_seam_type:["none","none","none","none"],filament_self_index:["1","2","3","4"],filament_settings_id:["PolyTerra PLA @BBL X1C","PolyTerra PLA @BBL X1C","PolyTerra PLA @BBL X1C","PolyTerra PLA @BBL X1C"],filament_shrink:["100%","100%","100%","100%"],filament_soluble:["0","0","0","0"],filament_start_gcode:[`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`,`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`,`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`,`; filament start gcode
{if  (bed_temperature[current_extruder] >55)||(bed_temperature_initial_layer[current_extruder] >55)}M106 P3 S200
{elsif(bed_temperature[current_extruder] >50)||(bed_temperature_initial_layer[current_extruder] >50)}M106 P3 S150
{elsif(bed_temperature[current_extruder] >45)||(bed_temperature_initial_layer[current_extruder] >45)}M106 P3 S50
{endif}

{if activate_air_filtration[current_extruder] && support_air_filtration}
M106 P3 S{during_print_exhaust_fan_speed_num[current_extruder]} 
{endif}`],filament_type:["PLA","PLA","PLA","PLA"],filament_velocity_adaptation_factor:["1","1","1","1"],filament_vendor:["Polymaker","Polymaker","Polymaker","Polymaker"],filament_wipe:["nil","nil","nil","nil"],filament_wipe_distance:["nil","nil","nil","nil"],filament_z_hop:["nil","nil","nil","nil"],filament_z_hop_types:["nil","nil","nil","nil"],filename_format:"{input_filename_base}_{filament_type[0]}_{print_time}.gcode",filter_out_gap_fill:"0",first_layer_print_sequence:["0"],flush_into_infill:"0",flush_into_objects:"0",flush_into_support:"1",flush_multiplier:["1"],flush_volumes_matrix:["0","211","197","167","167","0","180","167","624","632","0","528","296","317","167","0"],flush_volumes_vector:["140","140","140","140","140","140","140","140"],from:"project",full_fan_speed_layer:["0","0","0","0"],fuzzy_skin:"none",fuzzy_skin_point_distance:"0.8",fuzzy_skin_thickness:"0.3",gap_infill_speed:["250"],gcode_add_line_number:"0",gcode_flavor:"marlin",grab_length:["0"],has_scarf_joint_seam:"0",head_wrap_detect_zone:[],hole_coef_1:["0","0","0","0"],hole_coef_2:["-0.008","-0.008","-0.008","-0.008"],hole_coef_3:["0.23415","0.23415","0.23415","0.23415"],hole_limit_max:["0.22","0.22","0.22","0.22"],hole_limit_min:["0.088","0.088","0.088","0.088"],host_type:"octoprint",hot_plate_temp:["55","55","55","55"],hot_plate_temp_initial_layer:["55","55","55","55"],hotend_cooling_rate:["2"],hotend_heating_rate:["2"],impact_strength_z:["10","10","10","10"],independent_support_layer_height:"1",infill_combination:"0",infill_direction:"45",infill_jerk:"9",infill_lock_depth:"1",infill_rotate_step:"0",infill_shift_step:"0.4",infill_wall_overlap:"15%",initial_layer_acceleration:["500"],initial_layer_flow_ratio:"1",initial_layer_infill_speed:["105"],initial_layer_jerk:"9",initial_layer_line_width:"0.5",initial_layer_print_height:"0.2",initial_layer_speed:["50"],initial_layer_travel_acceleration:["6000"],inner_wall_acceleration:["0"],inner_wall_jerk:"9",inner_wall_line_width:"0.45",inner_wall_speed:["300"],interface_shells:"0",interlocking_beam:"0",interlocking_beam_layer_count:"2",interlocking_beam_width:"0.8",interlocking_boundary_avoidance:"2",interlocking_depth:"2",interlocking_orientation:"22.5",internal_bridge_support_thickness:"0.8",internal_solid_infill_line_width:"0.42",internal_solid_infill_pattern:"zig-zag",internal_solid_infill_speed:["250"],ironing_direction:"45",ironing_flow:"10%",ironing_inset:"0.21",ironing_pattern:"zig-zag",ironing_spacing:"0.15",ironing_speed:"30",ironing_type:"no ironing",is_infill_first:"0",layer_change_gcode:`; layer num/total_layer_count: {layer_num+1}/[total_layer_count]
; update layer progress
M73 L{layer_num+1}
M991 S0 P{layer_num} ;notify layer change`,layer_height:"0.2",line_width:"0.42",locked_skeleton_infill_pattern:"zigzag",locked_skin_infill_pattern:"crosszag",long_retractions_when_cut:["0"],long_retractions_when_ec:["0","0","0","0"],machine_end_gcode:`;===== date: 20240528 =====================
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract
G1 Z{max_layer_z + 0.5} F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos
G1 Y265 F3000

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
    M400 ; wait all motion done
    M991 S0 P-1 ;end smooth timelapse at safe pos
    M400 S3 ;wait for last picture to be taken
M623; end of "timelapse_record_flag"

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom
{if (max_layer_z + 100.0) < 250}
    G1 Z{max_layer_z + 100.0} F600
    G1 Z{max_layer_z +98.0}
{else}
    G1 Z250 F600
    G1 Z248
{endif}
M400 P100
M17 R ; restore z current

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0
;=====printer finish  sound=========
M17
M400 S1
M1006 S1
M1006 A0 B20 L100 C37 D20 M40 E42 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C46 D10 M80 E46 F10 N80
M1006 A44 B20 L100 C39 D20 M60 E48 F20 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C39 D10 M60 E39 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A0 B10 L100 C48 D10 M60 E44 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10  N100
M1006 A49 B20 L100 C44 D20 M100 E41 F20 N100
M1006 A0 B20 L100 C0 D20 M60 E0 F20 N100
M1006 A0 B20 L100 C37 D20 M30 E37 F20 N60
M1006 W

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power
M960 S5 P0 ; turn off logo lamp
`,machine_load_filament_time:"29",machine_max_acceleration_e:["5000","5000"],machine_max_acceleration_extruding:["20000","20000"],machine_max_acceleration_retracting:["5000","5000"],machine_max_acceleration_travel:["9000","9000"],machine_max_acceleration_x:["20000","20000"],machine_max_acceleration_y:["20000","20000"],machine_max_acceleration_z:["500","200"],machine_max_jerk_e:["2.5","2.5"],machine_max_jerk_x:["9","9"],machine_max_jerk_y:["9","9"],machine_max_jerk_z:["3","3"],machine_max_speed_e:["30","30"],machine_max_speed_x:["500","200"],machine_max_speed_y:["500","200"],machine_max_speed_z:["20","20"],machine_min_extruding_rate:["0","0"],machine_min_travel_rate:["0","0"],machine_pause_gcode:"M400 U1",machine_prepare_compensation_time:"260",machine_start_gcode:`;===== machine: X1 ====================
;===== date: 20240919 ==================
;===== start printer sound ================
M17
M400 S1
M1006 S1
M1006 A0 B10 L100 C37 D10 M60 E37 F10 N60
M1006 A0 B10 L100 C41 D10 M60 E41 F10 N60
M1006 A0 B10 L100 C44 D10 M60 E44 F10 N60
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N60
M1006 A46 B10 L100 C43 D10 M70 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A43 B10 L100 C0 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A41 B10 L100 C0 D10 M100 E41 F10 N100
M1006 A44 B10 L100 C0 D10 M100 E44 F10 N100
M1006 A49 B10 L100 C0 D10 M100 E49 F10 N100
M1006 A0 B10 L100 C0 D10 M100 E0 F10 N100
M1006 A48 B10 L100 C44 D10 M60 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A44 B10 L100 C0 D10 M90 E39 F10 N100
M1006 A0 B10 L100 C0 D10 M60 E0 F10 N100
M1006 A46 B10 L100 C43 D10 M60 E39 F10 N100
M1006 W
;===== turn on the HB fan =================
M104 S75 ;set extruder temp to turn on the HB fan and prevent filament oozing from nozzle
;===== reset machine status =================
M290 X40 Y40 Z2.6666666
G91
M17 Z0.4 ; lower the z-motor current
G380 S2 Z30 F300 ; G380 is same as G38; lower the hotbed , to prevent the nozzle is below the hotbed
G380 S2 Z-25 F300 ;
G1 Z5 F300;
G90
M17 X1.2 Y1.2 Z0.75 ; reset motor current to default
M960 S5 P1 ; turn on logo lamp
G90
M220 S100 ;Reset Feedrate
M221 S100 ;Reset Flowrate
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 5
M221 X0 Y0 Z0 ; turn off soft endstop to prevent protential logic problem
G29.1 Z{+0.0} ; clear z-trim value first
M204 S10000 ; init ACC set to 10m/s^2

;===== heatbed preheat ====================
M1002 gcode_claim_action : 2
M140 S[bed_temperature_initial_layer_single] ;set bed temp
M190 S[bed_temperature_initial_layer_single] ;wait for bed temp

{if scan_first_layer}
;=========register first layer scan=====
M977 S1 P60
{endif}

;=============turn on fans to prevent PLA jamming=================
{if filament_type[initial_no_support_extruder]=="PLA"}
    {if (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}
    M106 P3 S180
    {endif};Prevent PLA from jamming
    M142 P1 R35 S40
{endif}
M106 P2 S100 ; turn on big fan ,to cool down toolhead

;===== prepare print temperature and material ==========
M104 S[nozzle_temperature_initial_layer] ;set extruder temp
G91
G0 Z10 F1200
G90
G28 X
M975 S1 ; turn on
G1 X60 F12000
G1 Y245
G1 Y265 F3000
M620 M
M620 S[initial_no_support_extruder]A   ; switch material if AMS exist
    M109 S[nozzle_temperature_initial_layer]
    G1 X120 F12000

    G1 X20 Y50 F12000
    G1 Y-3
    T[initial_no_support_extruder]
    G1 X54 F12000
    G1 Y265
    M400
M621 S[initial_no_support_extruder]A
M620.1 E F{filament_max_volumetric_speed[initial_no_support_extruder]/2.4053*60} T{nozzle_temperature_range_high[initial_no_support_extruder]}

M412 S1 ; ===turn on filament runout detection===

M109 S250 ;set nozzle to common flush temp
M106 P1 S0
G92 E0
G1 E50 F200
M400
M104 S[nozzle_temperature_initial_layer]
G92 E0
G1 E50 F200
M400
M106 P1 S255
G92 E0
G1 E5 F300
M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20} ; drop nozzle temp, make filament shink a bit
G92 E0
G1 E-0.5 F300

G1 X70 F9000
G1 X76 F15000
G1 X65 F15000
G1 X76 F15000
G1 X65 F15000; shake to put down garbage
G1 X80 F6000
G1 X95 F15000
G1 X80 F15000
G1 X165 F15000; wipe and shake
M400
M106 P1 S0
;===== prepare print temperature and material end =====


;===== wipe nozzle ===============================
M1002 gcode_claim_action : 14
M975 S1
M106 S255
G1 X65 Y230 F18000
G1 Y264 F6000
M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]-20}
G1 X100 F18000 ; first wipe mouth

G0 X135 Y253 F20000  ; move to exposed steel surface edge
G28 Z P0 T300; home z with low precision,permit 300deg temperature
G29.2 S0 ; turn off ABL
G0 Z5 F20000

G1 X60 Y265
G92 E0
G1 E-0.5 F300 ; retrack more
G1 X100 F5000; second wipe mouth
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X100 F5000
G1 X70 F15000
G1 X90 F5000
G0 X128 Y261 Z-1.5 F20000  ; move to exposed steel surface and stop the nozzle
M104 S140 ; set temp down to heatbed acceptable
M106 S255 ; turn on fan (G28 has turn off fan)

M221 S; push soft endstop status
M221 Z0 ;turn off Z axis endstop
G0 Z0.5 F20000
G0 X125 Y259.5 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y262.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y260.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.5
G0 Z-1.01
G0 X131 F211
G0 X124
G0 Z0.5 F20000
G0 X125 Y261.0
G0 Z-1.01
G0 X131 F211
G0 X124
G0 X128
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300
G2 I0.5 J0 F300

M109 S140 ; wait nozzle temp down to heatbed acceptable
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000
G2 I0.5 J0 F3000

M221 R; pop softend status
G1 Z10 F1200
M400
G1 Z10
G1 F30000
G1 X128 Y128
G29.2 S1 ; turn on ABL
;G28 ; home again after hard wipe mouth
M106 S0 ; turn off fan , too noisy
;===== wipe nozzle end ================================

;===== check scanner clarity ===========================
G1 X128 Y128 F24000
G28 Z P0
M972 S5 P0
G1 X230 Y15 F24000
;===== check scanner clarity end =======================

;===== bed leveling ==================================
M1002 judge_flag g29_before_print_flag
M622 J1

    M1002 gcode_claim_action : 1
    G29 A X{first_layer_print_min[0]} Y{first_layer_print_min[1]} I{first_layer_print_size[0]} J{first_layer_print_size[1]}
    M400
    M500 ; save cali data

M623
;===== bed leveling end ================================

;===== home after wipe mouth============================
M1002 judge_flag g29_before_print_flag
M622 J0

    M1002 gcode_claim_action : 13
    G28

M623
;===== home after wipe mouth end =======================

M975 S1 ; turn on vibration supression

;=============turn on fans to prevent PLA jamming=================
{if filament_type[initial_no_support_extruder]=="PLA"}
    {if (bed_temperature[initial_no_support_extruder] >45)||(bed_temperature_initial_layer[initial_no_support_extruder] >45)}
    M106 P3 S180
    {endif};Prevent PLA from jamming
    M142 P1 R35 S40
{endif}
M106 P2 S100 ; turn on big fan ,to cool down toolhead

M104 S{nozzle_temperature_initial_layer[initial_no_support_extruder]} ; set extrude temp earlier, to reduce wait time

;===== mech mode fast check============================
G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q1 A7 B30 C80  H15 K0
M974 Q1 S2 P0

G1 X128 Y128 Z10 F20000
M400 P200
M970.3 Q0 A7 B30 C90 Q0 H15 K0
M974 Q0 S2 P0

M975 S1
G1 F30000
G1 X230 Y15
G28 X ; re-home XY
;===== mech mode fast check============================

{if scan_first_layer}
;start heatbed  scan====================================
M976 S2 P1
G90
G1 X128 Y128 F20000
M976 S3 P2  ;register void printing detection
{endif}

;===== nozzle load line ===============================
M975 S1
G90
M83
T1000
G1 X18.0 Y1.0 Z0.8 F18000;Move to start position
M109 S{nozzle_temperature[initial_no_support_extruder]}
G1 Z0.2
G0 E2 F300
G0 X240 E15 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
G0 Y11 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
G0 X239.5
G0 E0.2
G0 Y1.5 E0.700
G0 X231 E0.700 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
M400

;===== for Textured PEI Plate , lower the nozzle as the nozzle was touching topmost of the texture when homing ==
;curr_bed_type={curr_bed_type}
{if curr_bed_type=="Textured PEI Plate"}
G29.1 Z{-0.04} ; for Textured PEI Plate
{endif}

;===== draw extrinsic para cali paint =================
M1002 judge_flag extrude_cali_flag
M622 J1

    M1002 gcode_claim_action : 8

    T1000

    G0 F1200.0 X231 Y15   Z0.2 E0.741
    G0 F1200.0 X226 Y15   Z0.2 E0.275
    G0 F1200.0 X226 Y8    Z0.2 E0.384
    G0 F1200.0 X216 Y8    Z0.2 E0.549
    G0 F1200.0 X216 Y1.5  Z0.2 E0.357

    G0 X48.0 E12.0 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
    G0 X48.0 Y14 E0.92 F1200.0
    G0 X35.0 Y6.0 E1.03 F1200.0

    ;=========== extruder cali extrusion ==================
    T1000
    M83
    {if default_acceleration > 0}
        {if outer_wall_acceleration > 0}
            M204 S[outer_wall_acceleration]
        {else}
            M204 S[default_acceleration]
        {endif}
    {endif}
    G0 X35.000 Y6.000 Z0.300 F30000 E0
    G1 F1500.000 E0.800
    M106 S0 ; turn off fan
    G0 X185.000 E9.35441 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G0 X187 Z0
    G1 F1500.000 E-0.800
    G0 Z1
    G0 X180 Z0.3 F18000

    M900 L1000.0 M1.0
    M900 K0.040
    G0 X45.000 F30000
    G0 Y8.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3
    M400

    G0 X45.000 F30000
    M900 K0.020
    G0 X45.000 F30000
    G0 Y10.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3
    M400

    G0 X45.000 F30000
    M900 K0.000
    G0 X45.000 F30000
    G0 Y12.000 F30000
    G1 F1500.000 E0.800
    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 F1500.000 E-0.800
    G1 X183 Z0.15 F30000
    G1 X185
    G1 Z1.0
    G0 Y6.000 F30000 ; move y to clear pos
    G1 Z0.3

    G0 X45.000 F30000 ; move to start point

M623 ; end of "draw extrinsic para cali paint"


M1002 judge_flag extrude_cali_flag
M622 J0
    G0 X231 Y1.5 F30000
    G0 X18 E14.3 F{outer_wall_volumetric_speed/(0.3*0.5)     * 60}
M623

M104 S140


;=========== laser and rgb calibration ===========
M400
M18 E
M500 R

M973 S3 P14

G1 X120 Y1.0 Z0.3 F18000.0;Move to first extrude line pos
T1100
G1 X235.0 Y1.0 Z0.3 F18000.0;Move to first extrude line pos
M400 P100
M960 S1 P1
M400 P100
M973 S6 P0; use auto exposure for horizontal laser by xcam
M960 S0 P0

G1 X240.0 Y6.0 Z0.3 F18000.0;Move to vertical extrude line pos
M960 S2 P1
M400 P100
M973 S6 P1; use auto exposure for vertical laser by xcam
M960 S0 P0

;=========== handeye calibration ======================
M1002 judge_flag extrude_cali_flag
M622 J1

    M973 S3 P1 ; camera start stream
    M400 P500
    M973 S1
    G0 F6000 X228.500 Y4.500 Z0.000
    M960 S0 P1
    M973 S1
    M400 P800
    M971 S6 P0
    M973 S2 P0
    M400 P500
    G0 Z0.000 F12000
    M960 S0 P0
    M960 S1 P1
    G0 X221.00 Y4.50
    M400 P200
    M971 S5 P1
    M973 S2 P1
    M400 P500
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y11.0
    M400 P200
    M971 S5 P3
    G0 Z0.500 F12000
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y11.0
    M400 P200
    M971 S5 P4
    M973 S2 P0
    M400 P500
    M960 S0 P0
    M960 S1 P1
    G0 X221.00 Y4.50
    M400 P500
    M971 S5 P2
    M963 S1
    M400 P1500
    M964
    T1100
    G0 F6000 X228.500 Y4.500 Z0.000
    M960 S0 P1
    M973 S1
    M400 P800
    M971 S6 P0
    M973 S2 P0
    M400 P500
    G0 Z0.000 F12000
    M960 S0 P0
    M960 S1 P1
    G0 X221.00 Y4.50
    M400 P200
    M971 S5 P1
    M973 S2 P1
    M400 P500
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y11.0
    M400 P200
    M971 S5 P3
    G0 Z0.500 F12000
    M960 S0 P0
    M960 S2 P1
    G0 X228.5 Y11.0
    M400 P200
    M971 S5 P4
    M973 S2 P0
    M400 P500
    M960 S0 P0
    M960 S1 P1
    G0 X221.00 Y4.50
    M400 P500
    M971 S5 P2
    M963 S1
    M400 P1500
    M964
    T1100
    G1 Z3 F3000

    M400
    M500 ; save cali data

    M104 S{nozzle_temperature[initial_no_support_extruder]} ; rise nozzle temp now ,to reduce temp waiting time.

    T1100
    M400 P400
    M960 S0 P0
    G0 F30000.000 Y10.000 X65.000 Z0.000
    M400 P400
    M960 S1 P1
    M400 P50

    M969 S1 N3 A2000
    G0 F360.000 X181.000 Z0.000
    M980.3 A70.000 B{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60/4} C5.000 D{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*60} E5.000 F175.000 H1.000 I0.000 J0.020 K0.040
    M400 P100
    G0 F20000
    G0 Z1 ; rise nozzle up
    T1000 ; change to nozzle space
    G0 X45.000 Y4.000 F30000 ; move to test line pos
    M969 S0 ; turn off scanning
    M960 S0 P0


    G1 Z2 F20000
    T1000
    G0 X45.000 Y4.000 F30000 E0
    M109 S{nozzle_temperature[initial_no_support_extruder]}
    G0 Z0.3
    G1 F1500.000 E3.600
    G1 X65.000 E1.24726 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X70.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X75.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X80.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X85.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X90.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X95.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X100.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X105.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X110.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X115.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X120.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X125.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X130.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X135.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}

    ; see if extrude cali success, if not ,use default value
    M1002 judge_last_extrude_cali_success
    M622 J0
        M400
        M900 K0.02 M{outer_wall_volumetric_speed/(1.75*1.75/4*3.14)*0.02}
    M623

    G1 X140.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X145.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X150.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X155.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X160.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X165.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X170.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X175.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X180.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X185.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X190.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X195.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X200.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X205.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X210.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X215.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    G1 X220.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)/ 4 * 60}
    G1 X225.000 E0.31181 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
    M973 S4

M623

;========turn off light and wait extrude temperature =============
M1002 gcode_claim_action : 0
M973 S4 ; turn off scanner
M400 ; wait all motion done before implement the emprical L parameters
;M900 L500.0 ; Empirical parameters
M109 S[nozzle_temperature_initial_layer]
M960 S1 P0 ; turn off laser
M960 S2 P0 ; turn off laser
M106 S0 ; turn off fan
M106 P2 S0 ; turn off big fan
M106 P3 S0 ; turn off chamber fan

M975 S1 ; turn on mech mode supression
G90
M83
T1000
;===== purge line to wipe the nozzle ============================
G1 E{-retraction_length[initial_no_support_extruder]} F1800
G1 X18.0 Y2.5 Z0.8 F18000.0;Move to start position
G1 E{retraction_length[initial_no_support_extruder]} F1800
M109 S{nozzle_temperature_initial_layer[initial_no_support_extruder]}
G1 Z0.2
G0 X239 E15 F{outer_wall_volumetric_speed/(0.3*0.5)    * 60}
G0 Y12 E0.7 F{outer_wall_volumetric_speed/(0.3*0.5)/4* 60}
`,machine_switch_extruder_time:"0",machine_unload_filament_time:"28",master_extruder_id:"1",max_bridge_length:"0",max_layer_height:["0.28"],max_travel_detour_distance:"0",min_bead_width:"85%",min_feature_size:"25%",min_layer_height:["0.08"],minimum_sparse_infill_area:"15",mmu_segmented_region_interlocking_depth:"0",mmu_segmented_region_max_width:"0",name:"project_settings",nozzle_diameter:["0.4"],nozzle_flush_dataset:["0"],nozzle_height:"4.2",nozzle_temperature:["220","220","220","220"],nozzle_temperature_initial_layer:["220","220","220","220"],nozzle_temperature_range_high:["240","240","240","240"],nozzle_temperature_range_low:["190","190","190","190"],nozzle_type:["hardened_steel"],nozzle_volume:["107"],nozzle_volume_type:["Standard"],only_one_wall_first_layer:"0",ooze_prevention:"0",other_layers_print_sequence:["0"],other_layers_print_sequence_nums:"0",outer_wall_acceleration:["5000"],outer_wall_jerk:"9",outer_wall_line_width:"0.42",outer_wall_speed:["200"],overhang_1_4_speed:["0"],overhang_2_4_speed:["50"],overhang_3_4_speed:["30"],overhang_4_4_speed:["10"],overhang_fan_speed:["100","100","100","100"],overhang_fan_threshold:["50%","50%","50%","50%"],overhang_threshold_participating_cooling:["95%","95%","95%","95%"],overhang_totally_speed:["10"],override_filament_scarf_seam_setting:"0",physical_extruder_map:["0"],post_process:[],pre_start_fan_time:["0","0","0","0"],precise_outer_wall:"0",precise_z_height:"0",pressure_advance:["0.02","0.02","0.02","0.02"],prime_tower_brim_width:"3",prime_tower_enable_framework:"0",prime_tower_extra_rib_length:"0",prime_tower_fillet_wall:"1",prime_tower_flat_ironing:"0",prime_tower_infill_gap:"150%",prime_tower_lift_height:"-1",prime_tower_lift_speed:"90",prime_tower_max_speed:"90",prime_tower_rib_wall:"1",prime_tower_rib_width:"8",prime_tower_skip_points:"1",prime_tower_width:"35",print_compatible_printers:["Bambu Lab X1 Carbon 0.4 nozzle","Bambu Lab X1 0.4 nozzle","Bambu Lab P1S 0.4 nozzle","Bambu Lab X1E 0.4 nozzle"],print_extruder_id:["1"],print_extruder_variant:["Direct Drive Standard"],print_flow_ratio:"1",print_sequence:"by layer",print_settings_id:"0.20mm Standard @BBL X1C",printable_area:["0x0","256x0","256x256","0x256"],printable_height:"250",printer_extruder_id:["1"],printer_extruder_variant:["Direct Drive Standard"],printer_model:"Bambu Lab X1 Carbon",printer_notes:"",printer_settings_id:"Bambu Lab X1 Carbon 0.4 nozzle",printer_structure:"corexy",printer_technology:"FFF",printer_variant:"0.4",printhost_authorization_type:"key",printhost_ssl_ignore_revoke:"0",printing_by_object_gcode:"",process_notes:"",raft_contact_distance:"0.1",raft_expansion:"1.5",raft_first_layer_density:"90%",raft_first_layer_expansion:"-1",raft_layers:"0",reduce_crossing_wall:"0",reduce_fan_stop_start_freq:["1","1","1","1"],reduce_infill_retraction:"1",required_nozzle_HRC:["3","3","3","3"],resolution:"0.012",retract_before_wipe:["0%"],retract_length_toolchange:["2"],retract_lift_above:["0"],retract_lift_below:["249"],retract_restart_extra:["0"],retract_restart_extra_toolchange:["0"],retract_when_changing_layer:["1"],retraction_distances_when_cut:["18"],retraction_distances_when_ec:["0","0","0","0"],retraction_length:["0.8"],retraction_minimum_travel:["1"],retraction_speed:["30"],role_base_wipe_speed:"1",scan_first_layer:"1",scarf_angle_threshold:"155",seam_gap:"15%",seam_placement_away_from_overhangs:"0",seam_position:"aligned",seam_slope_conditional:"1",seam_slope_entire_loop:"0",seam_slope_gap:"0",seam_slope_inner_walls:"1",seam_slope_min_length:"10",seam_slope_start_height:"10%",seam_slope_steps:"10",seam_slope_type:"none",silent_mode:"0",single_extruder_multi_material:"1",skeleton_infill_density:"15%",skeleton_infill_line_width:"0.45",skin_infill_density:"15%",skin_infill_depth:"2",skin_infill_line_width:"0.45",skirt_distance:"2",skirt_height:"1",skirt_loops:"0",slice_closing_radius:"0.049",slicing_mode:"regular",slow_down_for_layer_cooling:["1","1","1","1"],slow_down_layer_time:["4","4","4","4"],slow_down_min_speed:["20","20","20","20"],slowdown_end_acc:["100000"],slowdown_end_height:["400"],slowdown_end_speed:["1000"],slowdown_start_acc:["100000"],slowdown_start_height:["0"],slowdown_start_speed:["1000"],small_perimeter_speed:["50%"],small_perimeter_threshold:["0"],smooth_coefficient:"150",smooth_speed_discontinuity_area:"1",solid_infill_filament:"1",sparse_infill_acceleration:["100%"],sparse_infill_anchor:"400%",sparse_infill_anchor_max:"20",sparse_infill_density:"15%",sparse_infill_filament:"1",sparse_infill_line_width:"0.45",sparse_infill_pattern:"grid",sparse_infill_speed:["270"],spiral_mode:"0",spiral_mode_max_xy_smoothing:"200%",spiral_mode_smooth:"0",standby_temperature_delta:"-5",start_end_points:["30x-3","54x245"],supertack_plate_temp:["45","45","45","45"],supertack_plate_temp_initial_layer:["45","45","45","45"],support_air_filtration:"0",support_angle:"0",support_base_pattern:"default",support_base_pattern_spacing:"2.5",support_bottom_interface_spacing:"0.5",support_bottom_z_distance:"0.2",support_chamber_temp_control:"0",support_critical_regions_only:"0",support_expansion:"0",support_filament:"0",support_interface_bottom_layers:"2",support_interface_filament:"0",support_interface_loop_pattern:"0",support_interface_not_for_body:"1",support_interface_pattern:"auto",support_interface_spacing:"0.5",support_interface_speed:["80"],support_interface_top_layers:"2",support_line_width:"0.42",support_object_first_layer_gap:"0.2",support_object_xy_distance:"0.35",support_on_build_plate_only:"0",support_remove_small_overhang:"1",support_speed:["150"],support_style:"default",support_threshold_angle:"30",support_top_z_distance:"0.2",support_type:"tree(auto)",symmetric_infill_y_axis:"0",temperature_vitrification:["45","45","45","45"],template_custom_gcode:"",textured_plate_temp:["55","55","55","55"],textured_plate_temp_initial_layer:["55","55","55","55"],thick_bridges:"0",thumbnail_size:["50x50"],time_lapse_gcode:`;========Date 20250206========
; SKIPPABLE_START
; SKIPTYPE: timelapse
M622.1 S1 ; for prev firmware, default turned on
M1002 judge_flag timelapse_record_flag
M622 J1
{if timelapse_type == 0} ; timelapse without wipe tower
M971 S11 C10 O0
M1004 S5 P1  ; external shutter
{elsif timelapse_type == 1} ; timelapse with wipe tower
G92 E0
G1 X65 Y245 F20000 ; move to safe pos
G17
G2 Z{layer_z} I0.86 J0.86 P1 F20000
G1 Y265 F3000
M400
M1004 S5 P1  ; external shutter
M400 P300
M971 S11 C10 O0
G92 E0
G1 X100 F5000
G1 Y255 F20000
{endif}
M623
; SKIPPABLE_END
`,timelapse_type:"0",top_area_threshold:"200%",top_color_penetration_layers:"5",top_one_wall_type:"all top",top_shell_layers:"5",top_shell_thickness:"1",top_solid_infill_flow_ratio:"1",top_surface_acceleration:["2000"],top_surface_jerk:"9",top_surface_line_width:"0.42",top_surface_pattern:"monotonicline",top_surface_speed:["200"],travel_acceleration:["10000"],travel_jerk:"9",travel_speed:["500"],travel_speed_z:["0"],tree_support_branch_angle:"45",tree_support_branch_diameter:"2",tree_support_branch_diameter_angle:"5",tree_support_branch_distance:"5",tree_support_wall_count:"-1",upward_compatible_machine:["Bambu Lab P1S 0.4 nozzle","Bambu Lab P1P 0.4 nozzle","Bambu Lab X1 0.4 nozzle","Bambu Lab X1E 0.4 nozzle","Bambu Lab A1 0.4 nozzle","Bambu Lab H2D 0.4 nozzle","Bambu Lab H2D Pro 0.4 nozzle","Bambu Lab H2S 0.4 nozzle"],use_firmware_retraction:"0",use_relative_e_distances:"1",version:"02.02.01.58",vertical_shell_speed:["80%"],volumetric_speed_coefficients:["0 0 0 0 0 0","0 0 0 0 0 0","0 0 0 0 0 0","0 0 0 0 0 0"],wall_distribution_count:"1",wall_filament:"1",wall_generator:"classic",wall_loops:"2",wall_sequence:"inner wall/outer wall",wall_transition_angle:"10",wall_transition_filter_deviation:"25%",wall_transition_length:"100%",wipe:["1"],wipe_distance:["2"],wipe_speed:"80%",wipe_tower_no_sparse_layers:"0",wipe_tower_rotation_angle:"0",wipe_tower_x:["165"],wipe_tower_y:["216.972"],wrapping_detection_gcode:"",wrapping_detection_layers:"20",wrapping_exclude_area:[],xy_contour_compensation:"0",xy_hole_compensation:"0",z_direction_outwall_speed_continuous:"0",z_hop:["0.4"],z_hop_types:["Auto Lift"]};async function yn(e){if(!e)throw new Error("No input provided");if(typeof e=="object")return e&&typeof e=="object"&&"default"in e&&e.default?e.default:e;if(typeof e=="string"){let s=e;/\.(json|js)$/i.test(s)||(s=s+".json");let r=await fetch(s);if(!r.ok)throw new Error(`Fetch failed (${r.status} ${r.statusText}) for ${s}`);return await r.json()}throw new Error(`Unsupported input type: ${typeof e}`)}function bn(e){return typeof e=="string"?JSON.stringify(e):typeof e=="number"||typeof e=="boolean"||e==null?String(e):Array.isArray(e)?`[Array(${e.length})]`:typeof e=="object"?"{Object}":String(e)}function lt(e,s,r="",t=[]){let i=r||"(root)",n=Object.prototype.toString.call(e),l=Object.prototype.toString.call(s);if(n!==l)return t.push(`Type mismatch at ${i}: ${n} != ${l}`),t;if(typeof e!="object"||e===null)return e!==s&&t.push(`Value mismatch at ${i}: ${bn(e)} != ${bn(s)}`),t;if(Array.isArray(e)){e.length!==s.length&&t.push(`Length mismatch at ${i}: ${e.length} != ${s.length}`);let p=Math.max(e.length,s.length);for(let w=0;w<p;w++)w in e?w in s?lt(e[w],s[w],`${i}[${w}]`,t):t.push(`Missing index in modified at ${i}[${w}]`):t.push(`Missing index in original at ${i}[${w}]`);return t}let _=new Set([...Object.keys(e),...Object.keys(s)]);for(let p of _){let w=Object.prototype.hasOwnProperty.call(e,p),y=Object.prototype.hasOwnProperty.call(s,p),c=r?`${r}.${p}`:p;w?y?lt(e[p],s[p],c,t):t.push(`Missing key in modified at ${c}`):t.push(`Missing key in original at ${c}`)}return t}async function _t({original:e=wn,modified:s=gn}={}){try{let r=await yn(e),t=await yn(s);console.groupCollapsed("%ccompareProjectSettingsFiles","color:#0aa"),console.log("Original:",r),console.log("Modified:",t);let i=lt(r,t);if(i.length===0)console.info("\u2705 Keine Unterschiede gefunden.");else{console.groupCollapsed(`\u26A0\uFE0F Unterschiede (${i.length})`);for(let n of i)console.log(n);console.groupEnd()}return console.groupEnd(),{ok:!0,differences:i.length,diffs:i}}catch(r){return console.error("\u274C compareProjectSettingsFiles failed:",r),{ok:!1,error:r?.message||String(r)}}}function vn(){document.getElementById("export")?.addEventListener("click",Ye),document.getElementById("export_gcode")?.addEventListener("click",hn),document.getElementById("reset")?.addEventListener("click",()=>location.reload()),document.getElementById("show_settings")?.addEventListener("change",d=>$e(d.target.checked));let e=document.getElementById("btn_compare_settings");e&&(e.addEventListener("click",async()=>{let d=e.textContent;e.disabled=!0,e.textContent="Comparing\u2026";try{let o=await _t();console.log("[compareProjectSettingsFiles] finished",o),alert("Vergleich abgeschlossen. Details stehen in der Konsole.")}catch(o){console.error("Fehler beim Vergleich:",o),alert("Vergleich fehlgeschlagen: "+(o?.message||o))}finally{e.disabled=!1,e.textContent=d}}),window.compareProjectSettingsFiles=_t);var s=document.getElementById("mode_a1m"),r=document.getElementById("mode_x1"),t=document.getElementById("mode_p1");s&&r&&t&&(s.disabled=!0,r.disabled=!0,t.disabled=!0,s.title=r.title=t.title="Printer mode is set automatically from the loaded file(s).");var i=document.getElementById("opt_purge");i&&(i.addEventListener("change",()=>{$.USE_PURGE_START=i.checked,console.log("USE_PURGE_START:",$.USE_PURGE_START)}),$.USE_PURGE_START=i.checked);var n=document.getElementById("opt_bedlevel_cooling");n&&(n.addEventListener("change",()=>{$.USE_BEDLEVEL_COOLING=n.checked,console.log("USE_BEDLEVEL_COOLING:",$.USE_BEDLEVEL_COOLING)}),$.USE_BEDLEVEL_COOLING=n.checked);let l=document.getElementById("file_name");if(l){l.addEventListener("click",()=>pt(l));let d=()=>mt(l,5,26);["keyup","keypress","input"].forEach(o=>l.addEventListener(o,d)),d()}xe(),Xt(),ge(),document.getElementById("filament_total")?.addEventListener("click",d=>{let o=d.target.closest(".f_color");if(!o)return;let u=+(o.dataset.slotIndex||0);Ct(u)}),document.getElementById("show_settings")?.addEventListener("change",d=>{$e(d.target.checked),xe()}),document.body.addEventListener("click",d=>{let o=d.target.closest(".p_filaments .f_color");o&&At(o)});let _=document.getElementById("playlist_ol");_&&new MutationObserver(o=>{for(let u of o)u.addedNodes?.forEach(b=>{b.nodeType===1&&b.matches?.("li.list_item")&&(Ne(b),ge(),Re(b))})}).observe(_,{childList:!0,subtree:!0});let p=document.getElementById("loops");p&&p.addEventListener("change",de),document.body.addEventListener("click",d=>{d.target.classList.contains("plate-remove")&&(xt(d.target),ge())}),document.body.addEventListener("change",d=>{d.target.classList.contains("p_rep")&&(de(),ge())}),document.body.addEventListener("click",d=>{let o=d.target.closest(".plate-duplicate");if(!o)return;d.preventDefault();let u=o.closest("li.list_item");u&&St(u)});let w=document.getElementById("opt_secure_pushoff"),y=document.getElementById("extra_pushoff_levels"),c=document.getElementById("extra_pushoff_levels_label"),v=document.getElementById("extra_pushoff_levels_help");function m(){let d=Le();y&&(y.disabled=!d),c&&(c.style.opacity=d?"1":"0.5"),v&&(v.style.display=d?"":"none")}w&&(w.addEventListener("change",m),m());let F=document.getElementById("list_item_prototype");$.li_prototype=F?.content?.firstElementChild||null,$.fileInput=document.getElementById("file"),$.playlist_ol=document.getElementById("playlist_ol"),$.err=document.getElementById("err"),$.p_scale=document.getElementById("progress_scale"),se(-1);let h=document.body,E=document.getElementById("drop_zone"),g=document.getElementById("drop_zone_instant");["dragend","dragleave","drop"].forEach(d=>{E.addEventListener(d,st),g.addEventListener(d,st)}),E.addEventListener("dragover",d=>Xe(d,d.target)),[...E.children].forEach(d=>{d.addEventListener("dragover",o=>Xe(o,o.target.parentElement))}),g.addEventListener("dragover",d=>Xe(d,d.target)),[...g.children].forEach(d=>{d.addEventListener("dragover",o=>Xe(o,o.target.parentElement))}),g.addEventListener("drop",d=>ot(d,!0)),E.addEventListener("drop",d=>ot(d,!1)),E.addEventListener("click",()=>{$.fileInput.click(),$.instant_processing=!1}),$.fileInput.addEventListener("change",function(d){var o=d.target.files;console.log("FILES:"),console.log(o);for(var u=0;u<o.length;u++)u+1==o.length?$.last_file=!0:$.last_file=!1,Ae(o[u]);console.log("FILES processing done...")})}window.addEventListener("DOMContentLoaded",()=>{vn()});})();
/*! Bundled license information:

jszip/dist/jszip.min.js:
  (*!
  
  JSZip v3.10.1 - A JavaScript class for generating and reading zip files
  <http://stuartk.com/jszip>
  
  (c) 2009-2016 Stuart Knightley <stuart [at] stuartk.com>
  Dual licenced under the MIT license or GPLv3. See https://raw.github.com/Stuk/jszip/main/LICENSE.markdown.
  
  JSZip uses the library pako released under the MIT license :
  https://github.com/nodeca/pako/blob/main/LICENSE
  *)
*/
//# sourceMappingURL=bundle.js.map
