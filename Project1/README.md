# Project 1 Automatic Server Compilation Testing

One of the most time-consuming part of project 1 is that we have to test compilation with more than ten version of main files, some of which should successfully compile while some should fail. It is relatively easy to do it on the local computer. Doing it on the remote server manually is another story. Therefore, I created this script to automatically test compilation on the remote server. Hopefully it will alleviate some of your burden and help you focus on the more important part of the project.

## Prerequisite

This testing script requires you to set up SSH agent in your local computer. Please follow the next few steps:

### Create the RSA Key Pair

Type in the following command in your terminal to create a ssh key in your laptop.

```bash
ssh-keygen -t rsa
```

Keep pressing ENTER until you see something like this:

```text
Enter file in which to save the key (/home/demo/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/demo/.ssh/id_rsa.
Your public key has been saved in /home/demo/.ssh/id_rsa.pub.
The key fingerprint is:
4a:dd:0a:c6:35:4e:3f:ed:27:38:8c:74:44:4d:93:67 demo@a
The key's randomart image is:
+--[ RSA 2048]----+
|          .oo.   |
|         .  o.E  |
|        + .  o   |
|     . = = .     |
|      = S = .    |
|     o + = +     |
|      . o + o .  |
|           . o   |
|                 |
+-----------------+
```

### Establish passwordless connection

Now we are going to copy your local public key into your SEASNet server. This will allow you to get connect to your SEASNet server using SSH encryption.

```bash
ssh-copy-id YOUR_SEASNET_ACCOUNT@lnxsrv.seas.ucla.edu
```

Now we are done for the prerequisite.

## Testing Script
