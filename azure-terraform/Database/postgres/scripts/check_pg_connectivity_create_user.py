# This python code is to test the connectivity from local machine after provisioning the 
# database using terraform.if you dont have psycopg2 installed then you can install the package
# and run the code. This code can also be used to create primary users in your database if required. 
# make sure create_user_flag=True is enabled.

# Initial draft - Aniket Mukherjee


import psycopg2
import getpass
from psycopg2 import extensions, sql

def create_user_and_assign_role(user_name,password,connection,database = "testdb-dev"):
    """ Create initial non superuser with basic privilege and return the user_name """
    autocommit = extensions.ISOLATION_LEVEL_AUTOCOMMIT
    connection.set_isolation_level( autocommit )
    cursor = connection.cursor()
    # cursor.execute(f'REVOKE CONNECT ON DATABASE "{database}" FROM {user_name} ;')
    # cursor.execute(f"DROP USER IF EXISTS {user_name} ;")
    cursor.execute(f"CREATE USER {user_name} WITH LOGIN NOSUPERUSER INHERIT CREATEDB NOCREATEROLE NOREPLICATION PASSWORD '{password}';")
    cursor.execute(f'GRANT CONNECT ON DATABASE "{database}" TO {user_name};')
    #cursor.execute(f'GRANT ALL PRIVILEGES ON DATABASE "{database}" TO {user_name};')
    cursor.close()
    return user_name

def get_database_login_connection(user,password,host,database):
    """ Return database connection object based on user and database details provided """
    connection = psycopg2.connect(user = user,
                                    password = password,
                                    host = host,
                                    port = "5432",
                                    database = database,
                                    sslmode= "require")
    return connection

def validate_database_connectivity(connection):
    """ Validate database connecttivity by executing SQL and fetching version of database"""
    cursor = connection.cursor()
    print ( connection.get_dsn_parameters(),"\n")

    cursor.execute("SELECT version();")
    record = cursor.fetchone()
    print ("You are connected to - ", record,"\n")
    cursor.close()

if __name__ == "__main__":
    """ Main function """
    
    create_user_flag=False
    database_name = "testdb-dev"
    database_server_name="rd-api-eastus2-dev-database-service"
    database_server_fqdn = "rd-api-eastus2-dev-database-service.postgres.database.azure.com"
    database_admin="admin"
    
    user = "{0}@{1}".format(database_admin,database_server_name)
    connection=None
    
    try:
        admin_password = getpass.getpass(
        prompt=f"Enter password for {database_admin}@{database_server_name} : "
        )
        
        connection=get_database_login_connection(user,admin_password,database_server_fqdn,database_name)
        validate_database_connectivity(connection)
        
        if(create_user_flag):
            new_user_name=input('Enter new postgres database user name to be created:')
            user_password = getpass.getpass(
            prompt=f"Enter password for {new_user_name}@{database_server_name} : "
            )
            new_user=create_user_and_assign_role(new_user_name,user_password,connection,database_name)
            if(new_user):
                print(f"{new_user} created successfully. Verifying connectivity with new user.")
                if(connection):
                        connection.close()
                connection=get_database_login_connection("{0}@{1}".format(new_user,database_server_name),user_password,database_server_fqdn,database_name)
                validate_database_connectivity(connection)

    except (Exception, psycopg2.Error) as error :
        print ("Error while connecting to PostgreSQL",error)
    finally:
            if(connection):
                connection.close()
                print("PostgreSQL connection is closed")