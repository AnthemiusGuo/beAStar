use strict;
use warnings;

sub lsr($) {
    sub lsr;
    my $cwd = shift;

    local *DH;
    if (!opendir(DH, $cwd)) {
        warn "Cannot opendir $cwd: $! $^E";
        return undef;
    }
    foreach (readdir(DH)) {
        if ($_ eq '.' || $_ eq '..') {
            next;
        }
        my $file = $cwd.'/'.$_;
        if (!-l $file && -d _) {
            $file .= '/';
            lsr($file);
        } else {
            process($file, $cwd);
        }
        
    }
    closedir(DH);
}


sub process($$) {
    my $file = shift;
    
    if ($file =~ /png|jpg|PNG|jpeg/) {
        print "dealing ".$file, "\n";
        `convert $file -resize 232.3108384% $file`;    
    } else {
        print "skip ".$file
    }
    
}



lsr('pic');
