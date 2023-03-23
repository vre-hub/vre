from sqlalchemy.exc import DatabaseError, TimeoutError
from rucio.db.sqla.session import get_session
from rucio.db.sqla import models
from jsonschema import validate
import datetime
import logging
import argparse
import json

# config file schema
config_schema = {
    "type": "object",
    "properties": {
        "DAYS_TO_KEEP": {
            "type": "integer",
            "minimum": 30,
        },
        "truncate_table": {
            "type":
                "object",
            "properties": {
                "MESSAGES_HISTORY": {
                    "type": "boolean"
                },
                "REQUESTS_HISTORY": {
                    "type": "boolean"
                },
                "RULES_HISTORY": {
                    "type": "boolean"
                },
                "RULES_HIST_RECENT": {
                    "type": "boolean"
                }
            },
            "required": [
                "MESSAGES_HISTORY", "REQUESTS_HISTORY", "RULES_HISTORY",
                "RULES_HIST_RECENT"
            ]
        },
    },
    "required": ["DAYS_TO_KEEP", "truncate_table"]
}

# tables model map
table_map = {
    "MESSAGES_HISTORY": models.MessageHistory,
    "REQUESTS_HISTORY": models.RequestHistory,
    "RULES_HISTORY": models.ReplicationRuleHistory,
    "RULES_HIST_RECENT": models.ReplicationRuleHistoryRecent
}


def _parse_arguments():
    """
    parse arguments
    """
    parser = argparse.ArgumentParser(
        description="Python script to clean up Rucio DB tables")

    parser.add_argument("--config",
                        required=True,
                        dest='config_file',
                        help="Configuration file")

    return parser.parse_args()


def main():

    args = _parse_arguments()
    config_file = args.config_file

    config_map = None
    with open(config_file) as json_file:
        config_map = json.load(json_file)
        validate(instance=config_map, schema=config_schema)

    DAYS_TO_KEEP = config_map['DAYS_TO_KEEP']
    truncate_table = config_map['truncate_table']

    logging.basicConfig(format='%(asctime)s - %(message)s',
                        datefmt='%d/%m/%y %H:%M:%S %Z',
                        level=logging.INFO)

    session = get_session()
    try:
        now_dt = datetime.datetime.now()
        delta_dt = now_dt - datetime.timedelta(days=DAYS_TO_KEEP)
        logging.info('Deletion START')
        for table, table_model in table_map.items():

            if truncate_table[table]:
                session.execute("TRUNCATE TABLE {} DROP STORAGE".format(table))
                logging.info("Truncating table:%s", table)
            else:
                logging.info(
                    "Deleting rows last updated before:%s from table:%s",
                    delta_dt.strftime('%d.%m.%Y'), table)
                query = session.query(table_model).with_for_update(
                    skip_locked=True)
                rows = query.where(table_model.updated_at <= delta_dt)
                rows.delete(synchronize_session=False)

        logging.info("Commiting changes to the DB")
        session.commit()
        logging.info('Deletion DONE')
    except TimeoutError as error:
        session.rollback()
        raise Exception(str(error))
    except DatabaseError as error:
        session.rollback()
        raise Exception(str(error))
    except Exception as error:
        session.rollback()
        raise
    finally:
        session.remove()


if __name__ == '__main__':
    main()
