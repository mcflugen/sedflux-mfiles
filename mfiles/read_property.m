%%
% \brief Read data from a SEDFLUX property file.
%
% Read data and header information from a sedflux output property
% file.  Depending on the version of Sedflux that created the
% output file, and the specified parameter/value pairs, the returned
% value is either a 2 or 3 dimensional array
%
% A series of parameter value pairs can be passed that control
% the way the data are presented.  Possible parameters are:
%  - Both SEDFLUX3D and SEDFLUX2D
%   -# time     : Give the time associated with this profile.  A label
%                 is placed on the image that gives this time.  This is
%                 typically used when making a movie from a series of
%                 profiles. [scalar]
%   -# skip     : Read only every skip-th column. [scalar]
%   -# dim      : Logical value that indicates if the returned data should
%                 be dimensionalized or scaled within a uint8. [scalar]
%   -# cols     : Read only these sediment columns. [scalar or vector]
%   -# water    : The value that denotes water. [scalar]
%   -# rock     : The value that denotes bedrock. [scalar]
%   -# clim     : Define the limits of the property. [vector]
%   -# mask     : Logical array that indicates which values should be
%                 imaged and which should be masked.  The size of the
%                 mask should be the same as that of the image.  [Vector]
%   -# func     : Function called to process the data before plotting.
%                 The function should accept a matrix as its only
%                 parameter. [function_handle]
%
% \param file_name    Name of the property file
% \param varargin     A series of parameter/value pairs
%
% \return [data,hdr] The data and header information from the
%         Sedflux property file
%

function [data, hdr] = read_property( file_name , varargin )
% READ_PROPERTY   Read a sedflux property file.
%
% DATA = READ_PROPERTY( filename ) Reads the data from the 
%  sedflux property file 'FILE NAME'
%
% SEE ALSO
%

valid_args = { 'skip'   , 'double'          , 0 ; ...
               'dim'    , 'logical'         , true ; ...
               'cols'   , 'double'          , [] ; ...
               'yslice' , 'double'          , [] ; ...
               'water'  , 'double'          , [] ; ...
               'rock'   , 'double'          , [] ; ...
               'clim'   , 'double'          , [] ; ...
               'mask'   , 'logical'         , false ; ...
               'func'   , 'function_handle' , [] };

values = parse_varargin( valid_args , varargin );

skip          = values{strmatch( 'skip'   , {valid_args{:,1}} , 'exact' )};
dim           = values{strmatch( 'dim'    , {valid_args{:,1}} , 'exact' )};
col_no        = values{strmatch( 'cols'   , {valid_args{:,1}} , 'exact' )};
yslice        = values{strmatch( 'yslice' , {valid_args{:,1}} , 'exact' )};
new_water_val = values{strmatch( 'water'  , {valid_args{:,1}} , 'exact' )};
new_rock_val  = values{strmatch( 'rock'   , {valid_args{:,1}} , 'exact' )};
data_lim      = values{strmatch( 'clim'   , {valid_args{:,1}} , 'exact' )};
mask          = values{strmatch( 'mask'   , {valid_args{:,1}} , 'exact' )};
func          = values{strmatch( 'func'   , {valid_args{:,1}} , 'exact' )};


   %% Try to open the file.
   fid = fopen(file_name,'r','ieee-be');
   if ( fid < 0 )
      error( ['Can not open file: ' file_name ] );
   end
   
   %% Read byte-order from the header.
   % Reopen the file with that byte-order.
   hdr = read_property_header( fid );
   if ( hdr.byte_order == 1234 )
      fclose( fid );
      fid = fopen(file_name,'r','ieee-le');
      hdr = read_property_header( fid );
   elseif ( hdr.byte_order == 4321 )
      fclose( fid );
      fid = fopen(file_name,'r','ieee-be');
      hdr = read_property_header( fid );
   end

   %% Read the data.
   %
   % If particular cores were specified, just read them.  Otherwise read the
   % entire data cube.
   if ( ~isempty( col_no ) )
      start_of_data = ftell( fid );
      if ( max(col_no) > hdr.n_y_cols*hdr.n_x_cols )
         [i,j] = ind2sub([hdr.n_y_cols hdr.n_x_cols],max(col_no))
         error( [ 'Core position (' ...
                  num2str((i*hdr.dy+hdr.ref_y)/1000) ...
                  ', ' ...
                  num2str((j*hdr.dx+hdr.ref_x)/1000) ...
                  ' km) out of range.'] );
      end
      %data = zeros(hdr.n_rows,length(col_no));

      for i=1:length(col_no)
         disp( ['Reading column ' col_no(i)] )
         fseek( fid , start_of_data , 'bof' );
         data(:,i) = read_compressed_grid( fid , 'lim' , [col_no(i) 1]*hdr.n_rows )';
      end
   elseif ( ~isempty( yslice ) )
      start_of_data = ftell( fid );

      col_id = sub2ind([hdr.n_y_cols hdr.n_x_cols], 1, yslice );
      fseek( fid , start_of_data , 'bof' );
      data = read_compressed_grid( fid , ...
               'lim' , [col_id hdr.n_x_cols]*hdr.n_rows )';
      data = reshape( data, hdr.n_rows, hdr.n_x_cols );

   else
      disp( 'Reading all data' )
      data = read_compressed_grid( fid );
      data = reshape( data , hdr.n_rows , hdr.n_y_cols , hdr.n_x_cols );
   end
   
   if ( skip ~= 0 )
      dataShort = data(1:skip+1:end,:);
      unit_height = unit_height*(skip+1);
      data = dataShort;
   end

   if ( ~isempty(func) )
      disp( 'Filtering the data.' );
      good_i = data>.9*hdr.water_val & data<.9*hdr.rock_val;
      data(good_i) = func( data(good_i) );
   end

   if ( isempty( data_lim ) )
      min_val = min(min(data(data>.9*hdr.water_val)));
      max_val = max(max(data(data<.9*hdr.rock_val)));
   else
      min_val = data_lim(1);
      max_val = data_lim(2);
   end

   disp( ['Maximum value: ' num2str(max_val) ]);
   disp( ['Minimum value: ' num2str(min_val) ]);

   if ( abs( max_val - min_val )/max_val < 1e-5 )
      max_val = max_val+1;
      min_val = min_val-1;
   end
   hdr.min_val = min_val;
   hdr.max_val = max_val;

   if ( ~(isscalar(mask) & ~mask) )
      is_rock         = data>.9*hdr.rock_val;
      data( ~mask )   = hdr.water_val;
      data( is_rock ) = hdr.rock_val;
   end
   
   if ( ~dim )
      disp( 'Rescaling the data between 0 and 255.' );
      is_water = data<.9*hdr.water_val;
      is_rock  = data>.9*hdr.rock_val;
      data_uint8 = zeros( size(data,1) , size(data,2) , 'uint8' );
      data_uint8 = (data-min_val)/(max_val-min_val)*252 + 2;
      data_uint8( is_water ) = 0;
      data_uint8( is_rock )  = 255;
      data_uint8( isnan(data)|isinf(data) ) = 1;
      data = data_uint8;
   else
      if ( ~isempty( new_water_val ) )
         data( data<.9*hdr.water_val ) = new_water_val;
      end
      if ( ~isempty( new_rock_val ) )
         data( data>.9*hdr.rock_val ) = new_rock_val;
      end
   end

   fclose(fid);

