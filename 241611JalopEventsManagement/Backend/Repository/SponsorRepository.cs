using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using _241611JalopEventsManagement.Backend.Models;

namespace _241611JalopEventsManagement.Backend.Repository
{
    /// <summary>
    /// Repository managing persistent operations on dbo.SponsorListTable.
    /// Manages corporate partnerships, branding associations, and event sponsor manifests.
    /// </summary>
    public class SponsorRepository
    {
        /// <summary>
        /// Retrieves all sponsors registered for a specific event.
        /// </summary>
        public List<SponsorModel> GetSponsorsByEventId(int eventId)
        {
            var list = new List<SponsorModel>();
            if (eventId <= 0)
            {
                return list;
            }

            const string sql = "dbo.usp_Sponsor_GetSponsorsByEventId";

            var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };
            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, param);

            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    list.Add(MapRowToSponsor(row));
                }
            }

            return list;
        }

        /// <summary>
        /// Retrieves sponsors for multiple events in a single batched query to avoid N+1 query overhead.
        /// </summary>
        public Dictionary<int, List<string>> GetSponsorsForEvents(IEnumerable<int> eventIds)
        {
            var dict = new Dictionary<int, List<string>>();
            if (eventIds == null)
            {
                return dict;
            }

            var validIds = eventIds.Where(id => id > 0).Distinct().ToList();
            if (validIds.Count == 0)
            {
                return dict;
            }

            string idList = string.Join(",", validIds);
            const string sql = "dbo.usp_Sponsor_GetSponsorsForEvents";

            DataTable dt = DatabaseConnection.ExecuteProcedureDataTable(sql, new SqlParameter("@EventIds", SqlDbType.NVarChar, -1) { Value = idList });
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    int evId = Convert.ToInt32(row["EventId"]);
                    string name = row["SponsorName"]?.ToString();
                    if (!string.IsNullOrWhiteSpace(name))
                    {
                        if (!dict.ContainsKey(evId))
                        {
                            dict[evId] = new List<string>();
                        }
                        dict[evId].Add(name.Trim());
                    }
                }
            }

            return dict;
        }

        /// <summary>
        /// Adds a single sponsor record for an event.
        /// Returns the newly generated SponsorEntryId.
        /// </summary>
        public int AddSponsor(SponsorModel sponsor)
        {
            if (sponsor == null)
            {
                throw new ArgumentNullException(nameof(sponsor), "Sponsor model cannot be null.");
            }

            if (string.IsNullOrWhiteSpace(sponsor.SponsorName))
            {
                throw new ArgumentException("Sponsor name is required.", nameof(sponsor.SponsorName));
            }

            if (sponsor.EventId <= 0)
            {
                throw new ArgumentException("EventId must reference a valid event.", nameof(sponsor.EventId));
            }

            const string sql = "dbo.usp_Sponsor_AddSponsor";

            var parameters = new[]
            {
                new SqlParameter("@SponsorName", SqlDbType.NVarChar, 150) { Value = sponsor.SponsorName.Trim() },
                new SqlParameter("@CreatedAt", SqlDbType.DateTime) { Value = sponsor.CreatedAt != default(DateTime) ? sponsor.CreatedAt : DateTime.Now },
                new SqlParameter("@EventId", SqlDbType.Int) { Value = sponsor.EventId }
            };

            object result = DatabaseConnection.ExecuteProcedureScalar(sql, parameters);
            if (result != null && int.TryParse(result.ToString(), out int newId))
            {
                sponsor.SponsorEntryId = newId;
                return newId;
            }

            throw new InvalidOperationException("Failed to retrieve generated SponsorEntryId from dbo.SponsorListTable.");
        }

        /// <summary>
        /// Adds multiple sponsors to an event in a single atomic transaction.
        /// </summary>
        public int AddSponsors(int eventId, IEnumerable<string> sponsorNames)
        {
            if (eventId <= 0 || sponsorNames == null)
            {
                return 0;
            }

            int addedCount = 0;
            DateTime now = DateTime.Now;

            foreach (var name in sponsorNames)
            {
                if (string.IsNullOrWhiteSpace(name))
                {
                    continue;
                }

                var sponsor = new SponsorModel
                {
                    EventId = eventId,
                    SponsorName = name.Trim(),
                    CreatedAt = now
                };

                AddSponsor(sponsor);
                addedCount++;
            }

            return addedCount;
        }

        /// <summary>
        /// Deletes a specific sponsor record by its primary key identifier.
        /// </summary>
        public bool DeleteSponsor(int sponsorEntryId)
        {
            if (sponsorEntryId <= 0)
            {
                return false;
            }

            const string sql = "dbo.usp_Sponsor_DeleteSponsor";
            var param = new SqlParameter("@SponsorEntryId", SqlDbType.Int) { Value = sponsorEntryId };

            int rows = DatabaseConnection.ExecuteProcedureNonQuery(sql, param);
            return rows > 0;
        }

        /// <summary>
        /// Deletes all sponsor associations for a specific event (e.g., when clearing or replacing sponsors).
        /// </summary>
        public bool DeleteSponsorsByEventId(int eventId)
        {
            if (eventId <= 0)
            {
                return false;
            }

            const string sql = "dbo.usp_Sponsor_DeleteSponsorsByEventId";
            var param = new SqlParameter("@EventId", SqlDbType.Int) { Value = eventId };

            int rows = DatabaseConnection.ExecuteProcedureNonQuery(sql, param);
            return rows > 0;
        }

        #region Helper Mapping

        private static SponsorModel MapRowToSponsor(DataRow row)
        {
            var sponsor = new SponsorModel
            {
                SponsorEntryId = Convert.ToInt32(row["SponsorEntryId"]),
                SponsorName = row["SponsorName"]?.ToString(),
                CreatedAt = Convert.ToDateTime(row["CreatedAt"]),
                EventId = Convert.ToInt32(row["EventId"])
            };

            if (row.Table.Columns.Contains("EventTitle") && row["EventTitle"] != DBNull.Value)
            {
                sponsor.EventTitle = row["EventTitle"].ToString();
            }

            return sponsor;
        }

        #endregion
    }
}
