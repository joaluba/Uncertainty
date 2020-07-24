function [v_HRIR_left, v_HRIR_right] = pick_HRIR(azimuth_r)
%This is a function to pick from a data base an impulse response
%corresponding to a given azimuth

azimuth_l=360-azimuth_r;

if azimuth_r==360 
    azimuth_r=0;
end
if azimuth_l==360 
    azimuth_l=0;
end


st_HRTF=load('hrtf_M_hrtf 256.mat');
v_pos=st_HRTF.meta.pos(:,2);
v_idx_elevation_zero=find(v_pos==0);
v_angles=st_HRTF.meta.pos(v_idx_elevation_zero,1);
hrtf_idx_left= v_idx_elevation_zero(find(v_angles==azimuth_l));
hrtf_idx_right= v_idx_elevation_zero(find(v_angles==azimuth_r));
v_HRIR_left=st_HRTF.hM(:,hrtf_idx_left,1);
v_HRIR_right=st_HRTF.hM(:,hrtf_idx_right,1);

end


