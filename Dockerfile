# Requires web server running, serving install files up via HTTP
# Used 'hello-world-nginx' container with the /website_files volume remapped to the project directory for
# this container.   'hello-world-nginx' was built from kinematic/http.

FROM registry.access.redhat.com/rhel7
MAINTAINER Craig Dougan "Craig.Dougan@gmail.com"
ENV ansible_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAiPBCWpyPRVpmGVMA6MiXm/aBQHln/6aKg3hwjER1gmcYIqHom3UXm7DtjogToBNq1nsyfx3IkIFTMxYLci75lMprJ4WlPzLhnY/UOjOf3FfEWN7hQhf1A/ETljk5oZXoLKmNi3dStl0D6l8UjBqodZzI9QfC3fzuk6a20EoSXRZdw32NGD6f8jZaZ0siLeXZTQicdaXW8+/K1E1GVDsOc900Hx/kDn6oLJ2mhEIvuMWjayvESMta+RUMytCVobvvCaYz+eQaXVwHsYu4fFDrfCscbueIryFv5+tNX9y2sXr5jFx1fTOH20ZUyQxNz8bcb5GKDEGyEisygzrNbCcN craig@Craigs-MacBook-Pro.local"

RUN cd /tmp && \
    yum-config-manager --enable rhel-7-server-optional-rpms && \
    yum-config-manager --enable rhel-7-server-extras-rpms && \
    yum-config-manager --enable rhel-7-server-supplementary-rpms && \
    yum install -y wget && \
    yum install -y unzip && \
    yum install -y openssh-server && \
    yum install -y sudo && \
    yum install -y psmisc && \
    yum install -y initscripts && \
    yum clean all && \
    mkdir -p /usr/local/bin && \
    useradd ansible && \
    chage -E -1 -M -1 -d -1 ansible && \
    echo 'ansible ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ansible && \
    mkdir -p /home/ansible/.ssh && \
    touch /home/ansible/.ssh/authorized_keys && \
    echo "${ansible_key}" > /home/ansible/.ssh/authorized_keys && \ 
    chown -R ansible:ansible /home/ansible/.ssh && \
    chmod 700 /home/ansible/.ssh && \
    chmod 600 /home/ansible/.ssh/authorized_keys && \
    rm -rf /run/nologin && \
    ssh-keygen -A

EXPOSE 22
ENTRYPOINT ["/usr/sbin/sshd", "-D"]
