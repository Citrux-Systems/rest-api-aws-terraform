import { APIGatewayProxyEvent, APIGatewayProxyResult } from "aws-lambda";

export const handler = async (
  event: APIGatewayProxyEvent
): Promise<APIGatewayProxyResult> => {
  console.log("Received event: ", event);

  try {

    switch (event.httpMethod) {
      case "GET":
        if (event.resource === "/users") {
          return await getAllUsers();
        }
        break;
      default:
        return createResponse(400, "Invalid request method");
    }
  } catch (error) {
    console.error("Error processing event", error);
    return createResponse(500, "Internal Server Error " + error.msg);
  }
};

// Clients functions
async function getAllUsers(): Promise<APIGatewayProxyResult> {
  const fakeUsers = [
    { username: "user1", email: 
      "user1@user1.com"
    },
    { username: "user2", email: 
      "user2@user2.com"
    },
  ]

  return createResponse(200, { users: fakeUsers });
}

function createResponse(statusCode: number, body: any): APIGatewayProxyResult {
  return {
    statusCode,
    body: JSON.stringify(body),
  };
}
