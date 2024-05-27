#!/usr/bin/env python3

import os
import sys

import radical.pilot as rp
import radical.utils as ru


# ------------------------------------------------------------------------------
#
if __name__ == '__main__':

    session = rp.Session()

    try:
        pmgr = rp.PilotManager(session=session)
        tmgr = rp.TaskManager(session=session)

        pd_init = {'resource'      : 'local.localhost',
                   'runtime'       : 10,
                   'nodes'         : 1,
                   'exit_on_error' : True,
                   'project'       : None,
                   'queue'         : None,
                   'access_schema' : None}

        pdesc = rp.PilotDescription(pd_init)
        pilot = pmgr.submit_pilots(pdesc)
        tmgr.add_pilots(pilot)

        td = rp.TaskDescription()
        td.executable     = '/bin/date'
        td.ranks          = 1
        td.cores_per_rank = 1

        tasks = tmgr.submit_tasks([td] * 128)
        tmgr.wait_tasks()

        for task in tasks:
            print('  * %s: %s [%s], %s' % (task.uid, task.state, task.exit_code,
                                           task.stdout.strip()))

    finally:
        session.close(download=True)


# ------------------------------------------------------------------------------

