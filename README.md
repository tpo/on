A few examples what you can do with 'on'
========================================

    $ on mail www do uptime
     14:57:17 up 12 days,  2:00,  2 users,  load average: 1.47, 1.62, 1.66
     14:57:21 up 5 days, 23:30,  0 users,  load average: 0.25, 0.20, 0.15

 
    $ cat ~/.on.config
    servers="mail www"
    $ on -p servers do "uname -a"
    mail: Linux
    www: Linux

 
    $ echo "some file with some content" > /tmp/foo
    $ on servers nfs put /tmp/foo
    foo                                          100%   28     0.0KB/s   00:00    
    foo                                          100%   28     0.0KB/s   00:00
    foo                                          100%   28     0.0KB/s   00:00

 
    $ on servers get /etc/debian_release /tmp/debian_release
    debian_version                               100%   11     0.0KB/s   00:00    
    debian_version                               100%   11     0.0KB/s   00:00    
    $ ls /tmp/debian_release*
    /tmp/debian_release_mail /tmp/debian_release_www

 
    $ cat /tmp/script
    #!/bin/sh
    echo "`hostname` says hello"
    $ on servers exec /tmp/script
    mail says hello
    www says hello

 
    $ on --help
    SYNOPSIS
      on [options] host_list [as remote_user] command
      on           host_list                  list
    
      COMMANDS
        do    "some; commands and -options"
        get   /remote/file [/local/file]
        put   /local/file [/remote/file]
        exec  /local/file ["some args"]*
        term
        list
    
    DESCRIPTION
    
        on executes "command" on one or more hosts defined by host_list.
    
        host_list is a list of host names separated by spaces. A host_list
        can also contain host_groups which will be expanded first. A
        host_group declaration will override a host of the same name. See
        CONFIGURATION below for host_group.
    
        The hosts can not be named "as", "do", "get", "put", "exec", "term"
        or "list". In case you use such names you need to alias them through
        a host_group.
    
        The command is allways executed sequentially, one host after the other.
    
        remote_user is not allowed to contain any metacharacters such as spaces.
    
        on is only really usefull if you distribute your ssh key to the
        target hosts.
    
    COMMANDS
        do    will execute the commands and parameters passed to the
              command as last parameter on the remote machines
    
        get   will copy the /remote/file from the given remote machines
              onto the local machine. If /local/file is not given, then
              the file will be copied to the same path as the remote file is.
    
              Relative remote/file paths will be copied to relative paths
              *starting from the current working directory*, same as scp would.
    
              The files will be given a postfix consisting of the name of the
              host the were fetched from.
    
        put   will copy the /local/file to given remote machines. If
              /remote/file is not given, then the file will be copied to
              the same path as /local/file. Since we're using scp to do
              the copying, giving a /local/file with a relative path and
              omitting the /remote/file the file will be put into the
              relative path starting from the HOME directory!
    
        exec  will execute the given local file with the arguments that
              follow on the remote machines
    
        list  will resolve the hosts - that is list the machines that
              are part of the host_list. Useful for debugging your config.
    
        term  will open a terminal (shell) on each remote machine
    
    OPTIONS
        -v be verbose on what on is doing (on which hosts!)
    
        -i interactive - stdin from the terminal will be forwarded to the
           remote session. Only available with the "exec" and "do" commands.
    
        -f (as in force) ignore errors when executing the "do", "get", "put"
           or "exec" commands. Just continue on the next host. Default is to
           abort on error.
    
        -o "SSH OPTIONS"
           options for ssh, will be passed on as is to ssh like this:
           ssh -o "SSH OPTIONS" ...
    
        -p prefix all output with hostname. Default is to display the output
           (stdout) unchanged. This option does not apply to the "get" and
           "put" commands.
    
    CONFIGURATION
        on will source ~/.on.config on startup. There you can define variables
        that define host_groups. If f.ex. you have a ~/.on.config that contains:
    
            my_servers="server1 server2"
    
        then you can call on like this:
    
            on my_servers do ls
    
        Since ~/.on.config is being sourced, you can use bash scripting there
        at will f.ex. to define groups of groups etc.
    
        Note that the my_servers declatation will override a possibly existing
        host with the strange name "my_servers".
    
        ANSIBLE
    
        If you want to reuse the host group definitions from ansible, then add
        this line to your ~/.on.config:
    
            parse_ansible_host_config [path_to_ansible_host_file]
    
        If you do not provide the 'path_to_ansible_host_file' argument, then on
        will read the default ansible host configuration file '/etc/ansible/hosts'.
    
        Note that dashes in group names will be replaced by underscores. A group
        named 'lxc-vms' will thus become 'lxc_vms'.
    
    ENVIRONMENT
        Setting DEBUG will execute on with the -x bash flag set.
    
    COPYRIGHT
        Copyright © 2012 Tomas Pospisek.
        License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
        This is free software: you are free to change and redistribute it.
        There is NO WARRANTY, to the extent permitted by law.
    
    AUTHOR
        Tomas Pospisek <tpo_deb@sourcepole.ch>
    
