using System;

namespace Engine.BL
{
    [Serializable]
    public class InvalidParameter : Exception
    {
        public InvalidParameter() { }
        public InvalidParameter(string msg) : base(msg) { }
    }

    [Serializable]
    public class SessionInvalida : Exception
    {
        public SessionInvalida() { }
        public SessionInvalida(string msg) : base(msg) { }
    }

    [Serializable]
    public class NotDataFound : Exception
    {
        public NotDataFound() { }
        public NotDataFound(string msg) : base(msg) { }
    }
    [Serializable]
    public class ASPXException : Exception
    {
        public ASPXException() { }
        public ASPXException(string msg) : base(msg) { }
    }


    [Serializable]
    public class DataBaseException : Exception
    {
        public DataBaseException() { }
        public DataBaseException(string msg) : base(msg) { }
    }

    [Serializable]
    public class XmlException : Exception
    {
        public string ref1 { get; set; }
        public string ref2 { get; set; }
        public XmlException() { }
        public XmlException(string msg) : base(msg) { }
        public XmlException(string msg, string Reference1, string Reference2) : base(msg) { ref1 = Reference1; ref2 = Reference2; }
    }

    [Serializable]
    public class ToEventLogException : Exception
    {
        public ToEventLogException() { }
        public ToEventLogException(string msg) : base(msg) { }
    }

    [Serializable]
    public class StopServiceException : Exception
    {
        public StopServiceException() { }
        public StopServiceException(string msg) : base(msg) { }
    }


    [Serializable]
    public class FileException : Exception
    {
        public FileException() { }
        public FileException(string msg) : base(msg) { }
    }


    [Serializable]
    public class ServerException : Exception
    {
        public ServerException() { }
        public ServerException(string msg) : base(msg) { }
    }

    [Serializable]
    public class DataServiceException : Exception
    {
        public string ref1 { get; set; }
        public string ref2 { get; set; }
        public DataServiceException() { }
        public DataServiceException(string msg) : base(msg) { }
        public DataServiceException(string msg, string Reference1, string Reference2) : base(msg) { ref1 = Reference1; ref2 = Reference2; }
    }

}