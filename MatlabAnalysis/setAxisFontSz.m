function setAxisFontSz(a, labelsFontSz)
a1=get(a,'XAxis');
set(a1,'FontSize',labelsFontSz);

a1=get(a,'YAxis');
set(a1,'FontSize',labelsFontSz);

a1=get(a,'ZAxis');
set(a1,'FontSize',labelsFontSz);
