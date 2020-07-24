function v_out=moving_av_circ(v_in,span)

hspan=floor(span/2);


for i=1:length(v_in)
    
    for s=1:floor(hspan)
        idx=i-(hspan-(s-1));
        if idx<=0
            idx_l(s)=length(v_in)+idx;
        else
            idx_l(s)=idx;
        end
             
        idx=i+(hspan-(s-1));
        if idx>length(v_in)
            idx_r(s)=idx-length(v_in);
        else
            idx_r(s)=idx;
        end
        
    end
    
 
    indices=[idx_l, i,fliplr(idx_r)];
    v_out(i)=1/length(indices)*sum(v_in(indices));
end
end