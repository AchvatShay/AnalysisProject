function mysave(f,filename)
if isempty(f)
    f=gcf;
end
pth=fileparts(filename);
mkNewFolder(pth);
saveas(f,[filename '.fig'],'fig');
saveas(f,[filename '.tif'],'tif');
print( f, '-depsc', [filename '.eps']);

% print(f,[filename '.pdf'],'-dpdf');
