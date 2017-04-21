import Fluent

// PostgreSQL flavored SQL serializer.
public final class PostgreSQLSerializer<E: Entity>: GeneralSQLSerializer<E> {
    public override func type(_ type: Field.DataType, primaryKey: Bool) -> String {
        switch type {
        case .id(let type):
            let typeString: String
            switch type {
            case .int:
                if primaryKey {
                    typeString = "SERIAL PRIMARY KEY"
                } else {
                    typeString = "INT UNSIGNED"
                }
            case .uuid:
                if primaryKey {
                    typeString = "CHAR(36) PRIMARY KEY"
                } else {
                    typeString = "CHAR(36)"
                }
            case .custom(let custom):
                typeString = custom
            }
            return typeString
        case .int:
            return "INT"
        case .string(let length):
            if let length = length {
                return "text"
            } else {
                return "text"
            }
        case .double:
            return "FLOAT"
        case .bool:
            return "TINYINT UNSIGNED"
        case .bytes:
            return "BYTEA"
        case .date:
            return "DATETIME"
        case .custom(let type):
            return type
        }
    }

    public override func deleteIndex(_ idx: RawOr<Index>) -> (String, [Node]) {
        var statement: [String] = []

        statement.append("ALTER TABLE")
        statement.append(escape(E.entity))
        statement.append("DROP INDEX")

        switch idx {
        case .raw(let raw, _):
            statement.append(raw)
        case .some(let idx):
            statement.append(escape(idx.name))
        }

        return (
            concatenate(statement),
            []
        )
    }
}
