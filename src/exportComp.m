function exportComp(EEM, path)
%% Export data file

for i = 1:EEM.nSample
   fileName = EEM.Sample{i};
   fid = fopen([path, '/component_intensity_', fileName, '.txt'], 'w');
   
   % 3 empty header line
   fprintf(fid, '\n\n\n');
   mat = squeeze(EEM.X(i, :, :));
 
   headerFmt = ['X/Y\t', repmat('%.1f\t', 1, EEM.nEx-1), '%.1f\n'];
   contentFmt = ['%.1f\t', repmat('%f\t', 1, EEM.nEx-1), '%f\n'];
   fprintf(fid, headerFmt, EEM.Ex); 
   
   for k = 1:EEM.nEm
       fprintf(fid, contentFmt, EEM.Em(k), mat(k, :));
   end
end

fclose(fid);

end