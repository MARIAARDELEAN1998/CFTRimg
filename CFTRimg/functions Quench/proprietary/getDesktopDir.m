function desktopDir = getDesktopDir

% if ispc
%     userDir = winqueryreg('HKEY_CURRENT_USER',...
%         ['Software\Microsoft\Windows\CurrentVersion\' ...
%          'Explorer\Shell Folders'],'Personal');
% else
%     userDir = char(java.lang.System.getProperty('user.home'));
% end

if ispc
    desktopDir = winqueryreg('HKEY_CURRENT_USER',...
        ['Software\Microsoft\Windows\CurrentVersion\' ...
         'Explorer\Shell Folders'],'Desktop');
else
    desktopDir = fullfile('~','Desktop');
end