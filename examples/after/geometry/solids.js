// Generated by NeptuneCoffee 0.2.3
// path: geometry/solids.js
define([
  './solids/namespace',
  './solids/cone'
], function(Solids, Cone) {
  if (typeof Cone == 'function') {Solids.Cone = Cone; Cone.namespace = Solids;}
  return Solids;
});
