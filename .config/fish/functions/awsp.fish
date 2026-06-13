function awsp --description 'Interactively pick an AWS profile, logging in via SSO if needed'
    set -l profile (aws configure list-profiles | fzf --prompt 'AWS profile> ' --height 40% --reverse)
    test -n "$profile"; or return 1

    set -gx AWS_PROFILE $profile

    # Refresh the SSO token if the current one is missing or expired.
    if not aws sts get-caller-identity >/dev/null 2>&1
        aws sso login; or return 1
    end

    echo "AWS_PROFILE=$profile"
end
