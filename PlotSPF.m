function PlotSPF(PFpts, Data, varargin)
% PlotSPF - plot point data on sphere
%
%   USAGE:
%
%   PlotSPF(PFpts, Data)
%   PlotSPF(PFpts, Data, varargin)
%
%   INPUT:
%
%   PFpts
%       pole figure points on the sphere (scattering vectors) (n x 3)
%
%   Data
%       scalar values corresponding to PFpts (n x 1)
%
%   These arguments can be followed by a list of
%   parameter/value pairs which control certain plotting
%   features.  Options are:
%
%   'Title'            title of the figure (default is 'SPF')
%   'ViewAngle'        angle to view the pole figure from
%                      default is [-223 26]
%   'DataRange'        range of the Data to determine the colors
%                      default is [-1 1]
%   'xaxis'            label for the x-axis
%                      default is 'x'
%   'yaxis'            label for the y-axis
%                      default is 'y'
%   'zaxis'            label for the z-axis
%                      default is 'z'
%   'ShowSurf'         on|{off}
%                      to display the PF surface
%
%   OUTPUT:  none
%
%   NOTE:
%           This function is similar to PlotPoints
%

NumDataPts1 = length(Data);
NumDataPts2 = size(PFpts,1);
if NumDataPts1 ~= NumDataPts2
    disp('number of scattering vectors does not match number of data points ...')
    return
elseif NumDataPts1 == 0
    disp('empty pf ...')
    return
end
NumDataPts  = NumDataPts1;

if NumDataPts ~= 0
    % define DataRange
    DataMax = max(Data);
    DataMin = min(Data);
    if DataMax > 0
        DataMax = DataMax + 0.01*DataMax;
    else
        DataMax = DataMax - 0.01*DataMax;
    end
    if DataMin > 0
        DataMin = DataMin - 0.01*DataMin;
    else
        DataMin = DataMin + 0.01*DataMin;
    end
    DataRange   = [DataMin DataMax];
else
    DataRange   = [-1 1];
end

% default options
optcell = {...
    'Title', 'SPF', ...
    'ViewAngle', [-223 26], ...
    'DataRange', DataRange, ...
    'xaxis', 'x', ...
    'yaxis', 'y', ...
    'zaxis', 'z', ...
    'ShowSurf', 'on', ...
    };

% update option
opts    = OptArgs(optcell, varargin);

% define colors
ncmap   = 256;
cmap    = jet(ncmap);
dData   = opts.DataRange(2) - opts.DataRange(1);
PFptColor   = round((ncmap-1)*(Data - opts.DataRange(1))./dData) + 1;

% now plot!
% PLOT PF SURFACE
if strcmpi(opts.ShowSurf, 'on')
    [xSPH, ySPH, zSPH]  = sphere(24);
    mesh(xSPH, ySPH, zSPH, ...
        'EdgeColor', 'k', ...
        'FaceColor', [1 1 1], ...
        'LineStyle', '-', ...
        'FaceAlpha', 0.80);
    axis equal
    hold on
    
    quiver3(1, 0, 0, 0.5, 0, 0, ...
        'Color', 'k', ...
        'LineWidth', 2)
    text(1.7, 0, 0, opts.xaxis, ...
        'FontSize', 16, 'FontWeight', 'bold')
    quiver3(0, 1, 0, 0, 0.5, 0, ...
        'Color', 'k', ...
        'LineWidth', 2)
    text(0, 1.6, 0, opts.yaxis, ...
        'FontSize', 16, 'FontWeight', 'bold')
    quiver3(0, 0, 1, 0, 0, 0.5, ...
        'Color', 'k', ...
        'LineWidth', 2)
    text(0, 0, 1.6, opts.zaxis, ...
        'FontSize', 16, 'FontWeight', 'bold')
end

for i = 1:1:NumDataPts
    if PFptColor(i) > 0 & PFptColor(i) <= ncmap
        plot3(...
            PFpts(i,1), PFpts(i,2), PFpts(i,3), ...
            'Marker', 'o', ...
            'MarkerFaceColor', cmap(PFptColor(i), :), ...
            'MarkerEdgeColor', cmap(PFptColor(i), :), ...
            'MarkerSize', 5);
        hold on
    end
end
axis equal off

title(opts.Title, ...
    'FontSize', 12, 'FontWeight', 'bold')
view(opts.ViewAngle);

cb  = colorbar;
set(cb, 'FontSize', 16, 'FontWeight', 'bold', ...
    'Location', 'SouthOutside')
caxis(opts.DataRange);

hold off