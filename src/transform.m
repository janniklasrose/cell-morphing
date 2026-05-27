function [xy_points] = transform(xy_points, imageSize, m_per_px, imageOrigin)
    %TRANSFORM Convert image coordinates to real-world coordinates.
    %   XY_POINTS = TRANSFORM(XY_POINTS, IMAGESIZE, M_PER_PX)
    %   XY_POINTS = TRANSFORM(XY_POINTS, IMAGESIZE, M_PER_PX, IMAGEORIGIN)
    %
    %   XY_POINTS is expected to be an Nx2 numeric array of vertices.
    %
    %   The default IMAGEORIGIN is [1, imageSize(1)], which matches the
    %   image-coordinate convention used elsewhere in this project.
    %
    %   The transformation performs:
    %     1. translation so the chosen origin becomes [0, 0]
    %     2. mirroring of the y-axis to switch from image to Cartesian coords
    %     3. reversal of vertex order to keep clockwise orientation
    %     4. scaling from pixels to meters
    %
    %   Coordinate sketch, with the default origin at the top-left corner:
    %
    %   image coords         shift origin          mirror y-axis
    %      [1, 1]      ->    [ 0 , -(M-1)]   ->    [ 0 ,  M-1]
    %      [1, M]      ->    [ 0 ,    0  ]   ->    [ 0 ,   0 ]
    %      [N, 1]      ->    [N-1, -(M-1)]   ->    [N-1,  M-1]
    %      [N, M]      ->    [N-1,    0  ]   ->    [N-1,   0 ]
    %
    %   Example for a single vertex:
    %      [x, y]  ->  [x - 1, y - M]  ->  [x - 1, M - y]  ->  *m_per_px

    narginchk(3, 4);
    validateattributes(xy_points, {'numeric'}, {'2d', 'ncols', 2}, mfilename, 'xy_points');
    validateattributes(imageSize, {'numeric'}, {'vector', 'numel', 2, 'positive'}, mfilename, 'imageSize');
    validateattributes(m_per_px, {'numeric'}, {'nonempty', 'real', 'positive'}, mfilename, 'm_per_px');
    if nargin < 4
        imageOrigin = [1, imageSize(1)];
    end
    validateattributes(imageOrigin, {'numeric'}, {'vector', 'numel', 2}, mfilename, 'imageOrigin');

    % Translate, mirror and scale a vertex array.
    xy_points = xy_points - imageOrigin(:).'; % translate
    xy_points = xy_points .* [1, -1] .* m_per_px(:).'; % mirror y-axis & scale
    xy_points = flipud(xy_points); % restore winding order after flipping
end
