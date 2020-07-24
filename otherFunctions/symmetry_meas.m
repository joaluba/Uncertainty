function v_Symmetry= symmetry_meas(v_Sig)


v_Symmetry=zeros(size(v_Sig));
for i =1:length(v_Sig)
    
    for r=1:1:length(v_Sig)/2+1;
        
        right=i+r;
        if right>length(v_Sig)
            right=right-length(v_Sig);
        end
        
        left=i-r;
        if left<1
            left =length(v_Sig)+left;
        end
        v_symmetry_x(r+1)=abs(v_Sig(right) -v_Sig(left));
    end
    
    symmetry_x=mean(v_symmetry_x);
    
    v_Symmetry(i)=symmetry_x;

end


end