function longest = longestConsecutiveOnes(vec)

if all(vec==0)
    longest=0;
    return;
end

longest = 0;
last_length = 0;

for i=1:length(vec)
    if vec(i)==1
        last_length=last_length+1;
        if last_length>longest
            longest=last_length;
        end
    else
        last_length=0;
    end
end
end